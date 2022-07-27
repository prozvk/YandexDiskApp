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
        
    init(viewModel: ViewModelProtocol = DIContainer.shared.resolve(type: MainViewModel.self)) {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0), heightDimension: NSCollectionLayoutDimension.fractionalWidth(0.65))
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
        
        super.init(collectionViewLayout: layout)
        
        self.viewModel = viewModel
        
        self.viewModel.filesDidChangedHandler = { [weak self] in
            self?.applySnapshot()
            self?.footerView?.activityIndicator.stopAnimating()
            self?.footerView?.photosNumberLabel.isHidden = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
                
        collectionView.backgroundColor = .white
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "reuseId")
                
        setupNavigatioBar()
                            
        prepareFiles()
    }
    
    func prepareFiles() {
        viewModel?.prepareFiles()
    }
    
    func setupNavigatioBar() {
        title = "Мои файлы"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 24)!]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 36)!]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .white
        
//        let leftButton = UIButton()
//        leftButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: nil), for: .normal)
//        leftButton.setTitle("кнопка", for: .normal)
//        leftButton.setTitleColor(.black, for: .normal)
//        leftButton.backgroundColor = .red
//        leftButton.heightAnchor.constraint(equalToConstant: (navigationController?.navigationBar.bounds.height)!).isActive = true
//        leftButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
//        view.addSubview(leftButton)
//        leftButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        leftButton.translatesAutoresizingMaskIntoConstraints = false
//
////        let leftItem = UIBarButtonItem(customView: leftButton)
////        navigationItem.leftBarButtonItem = leftItem
//
//        navigationItem.titleView = leftButton
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.contentSize.height

        print("scrollView.contentOffset.y", offsetY)
        print("scrollView.contentSize.height", height)
        print("scrollView.frame.size.height", scrollView.frame.size.height, "\n\n\n")

        if offsetY + 300 > height - scrollView.frame.size.height {
            print("CALL API")

            footerView?.photosNumberLabel.isHidden = true
            footerView?.activityIndicator.startAnimating()

            prepareFiles()
        }
    }
}

//extension MainCollectionViewController: AuthViewControllerDelegate {
//    
//    func handleTokenChanged() {
//        prepareFiles()
//    }
//    
//    func presentAuthViewController() {
//        let requsetTokenViewController = AuthViewController()
//        requsetTokenViewController.delegate = self
//        requsetTokenViewController.modalPresentationStyle = .fullScreen
//        navigationController?.present(requsetTokenViewController, animated: false, completion: nil)
//        return
//    }
//}

//Пока что cell layout здесь:

// MARK: - DataSorce

extension MainCollectionViewController {
    
    private func makeDataSource() -> DataSource {
        
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, file) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseId", for: indexPath) as! MainCollectionViewCell
            cell.nameLabel.text = file.name
            guard let image = file.image else { return cell }
            
            cell.imageView.image = image
            cell.imageView.contentMode = .scaleAspectFill
            return cell
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView> (elementKind: MainCollectionViewController.sectionHeaderElementKind) { (supplementaryView, elementKind, indexPath) in
            
            supplementaryView.sectionName.text = "Изображения"
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
}

// MARK: - Snaphsot

extension MainCollectionViewController {
    
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        //snapshot.appendItems(files, toSection: 0)
        snapshot.appendItems(viewModel.files, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
