//
//  ViewController.swift
//  YandexDiskRelease

//
//  Created by MacPro on 19.07.2022.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, File>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, File>
    
    private lazy var dataSource = makeDataSource()
    
    //var files: [File] = []
    
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
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                         heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: MainCollectionViewController.sectionHeaderElementKind,
                                                                            alignment: .top)
 
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        
        super.init(collectionViewLayout: layout)
        
        self.viewModel = viewModel
        
        self.viewModel.filesDidChangedHandler = { [weak self] in
            self?.applySnapshot()
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
        
//        ApiManager.shared.fetchFiles { (response) in
//            guard let items = response.items else { return }
//            for item in items {
//                ApiManager.shared.loadImage(url: item.preview!) { (image) in
//                    let file = File(image: image!, name: item.name!, size: String(item.size!))
//                    self.files.append(file)
//                    self.applySnapshot()
//                }
//            }
//        }
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
    
}

extension MainCollectionViewController: AuthViewControllerDelegate {
    
    func handleTokenChanged() {
        prepareFiles()
    }
    
    func presentAuthViewController() {
        let requsetTokenViewController = AuthViewController()
        requsetTokenViewController.delegate = self
        requsetTokenViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(requsetTokenViewController, animated: false, completion: nil)
        return
    }
}

//Пока что cell layout здесь:

// MARK: - DataSorce

extension MainCollectionViewController {
    
    func makeDataSource() -> DataSource {
        
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, file) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseId", for: indexPath) as! MainCollectionViewCell
            cell.nameLabel.text = file.name
            cell.imageView.image = file.image
            return cell
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView> (elementKind: MainCollectionViewController.sectionHeaderElementKind) { (supplementaryView, elementKind, indexPath) in
            supplementaryView.sectionName.text = "Изображения"
        }
        
        dataSource.supplementaryViewProvider = { (supplementaryView, elementKind, indexPath) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
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
