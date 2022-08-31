//
//  ViewController.swift
//  YandexDiskRelease

//
//  Created by MacPro on 19.07.2022.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    static let sectionFooterElementKind = "section-footer-element-kind"
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, File>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, File>
    
    private lazy var dataSource = makeDataSource()
    
    var footerView: FooterSupplementaryView?
    var viewModel: ViewModelProtocol!
    
    let transitionDelegate = TransitionController()
    
    var selectedCellImageView: UIImageView!
    var selectedCellImageRect: CGRect!
    
    init(viewModel: ViewModelProtocol = DIContainer.shared.resolve(type: MainViewModel.self)) {
        super.init(collectionViewLayout: setuplayout())
        
        self.viewModel = viewModel
        
        setupViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
                
        collectionView.backgroundColor = .white
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "reuseId")
                
        collectionView.refreshControl = UIRefreshControl()
        
//        setupNavigatioBar()
        
        applySnapshot()
                            
        prepareFiles()
    }
    
    fileprivate func setupViewModel() {
        self.viewModel.filesDidChangedHandler = { [weak self] count in
            self?.applySnapshot()
            self?.footerView?.photosNumberLabel.text = "\(count) файла(-ов)"
        }
        
        self.viewModel.fileGetImage = { [weak self] file in
            self?.updateSnapshot(with: file)
        }
        
        self.viewModel.pagingStateChanged = { [weak self] isPaging in
            self?.footerView?.photosNumberLabel.isHidden = isPaging
            let ai = self?.footerView?.activityIndicator
            isPaging ? ai?.startAnimating() : ai?.stopAnimating()
        }
    }
    
    func prepareFiles() {
        viewModel.prepareFiles()
    }
    
//    func setupNavigatioBar() {
//        title = "Мои файлы"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 24)!]
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 36)!]
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.barTintColor = .white
//    }
    
    // pull to refresh
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.contentSize.height

        if offsetY > height - scrollView.frame.size.height && height != 0 {
            prepareFiles()
        }
    }
    
    // refresh at the end
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.files.count - 1 && viewModel.files.count != 0 {
            prepareFiles()
        }
    }
}

// MARK: - DataSorce

extension MainCollectionViewController {
    
    private func makeDataSource() -> DataSource {
        
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, file) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseId", for: indexPath) as! MainCollectionViewCell
            
            cell.configure(file: file)
            
            return cell
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView> (elementKind: MainCollectionViewController.sectionHeaderElementKind) { (supplementaryView, elementKind, indexPath) in
            
            supplementaryView.sectionName.text = "Мои файлы"
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<FooterSupplementaryView> (elementKind: MainCollectionViewController.sectionFooterElementKind) {
            (footerSupplementaryView, elementKind, indexPath) in
            
            //MARK: - TODO: text = viewModel.правильное описание количества фоток на русском языке()
            
            self.footerView = footerSupplementaryView
            footerSupplementaryView.photosNumberLabel.text = "\(self.viewModel.files.count) файла(-ов)"
        }
        
        dataSource.supplementaryViewProvider = { (supplementaryView, elementKind, indexPath) in
            switch elementKind {
            case MainCollectionViewController.sectionHeaderElementKind:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            case MainCollectionViewController.sectionFooterElementKind:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
            default:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
        }
        
        return dataSource
    }
    
    //MARK: - Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCellWithImageView
        selectedCellImageView = cell.imageView
        selectedCellImageRect = cell.imageView.convert(cell.imageView.frame, to: view)
        
        DIContainer.shared.register(type: DetailViewModel.self,
                                    component: DetailViewModel(file: viewModel.files[indexPath.row]))
        
        let detail = DetailView()
        detail.modalPresentationStyle = .custom
        detail.transitioningDelegate = transitionDelegate
        present(detail, animated: true, completion: nil)
    }
}

// MARK: - Snaphsot

extension MainCollectionViewController {
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.files, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateSnapshot(with file: File) {
        var updatedSnapshot = dataSource.snapshot()
        
        if let datasourceIndex = updatedSnapshot.indexOfItem(file) {
            let item = self.viewModel.files[datasourceIndex]
            updatedSnapshot.reloadItems([item])
            self.dataSource.apply(updatedSnapshot, animatingDifferences: false)
        }
    }
}

// MARK: - Layout

fileprivate func setuplayout() -> UICollectionViewCompositionalLayout {
   let layout =  UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                                               heightDimension: NSCollectionLayoutDimension.fractionalWidth(0.65))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .estimated(44))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: MainCollectionViewController.sectionHeaderElementKind,
                                                                        alignment: .top)
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: MainCollectionViewController.sectionFooterElementKind,
                                                                        alignment: .bottom)

        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        return section
    }
    return layout
}

