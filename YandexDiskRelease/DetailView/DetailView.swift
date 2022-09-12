//
//  DetailView.swift
//  YandexDiskRelease
//
//  Created by MacPro on 21.08.2022.
//

import UIKit

class DetailView: UIViewController {
        
    weak var viewModel: DetailViewModelProtocol?
        
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        button.layer.cornerRadius = 33
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 12
        button.backgroundColor = .white
        button.setImage(UIImage(named: "saveButtonImage"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return button
    }()
    
    init(viewModel: DetailViewModelProtocol = DIContainer.shared.resolve(type: DetailViewModel.self)) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLayout()
        
        fillUI()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        saveButton.frame = saveButton.frame.offsetBy(dx: 0, dy: 100)
        dismissButton.frame = dismissButton.frame.offsetBy(dx: 0, dy: -100)
        
        UIView.animate(withDuration: 0.25) { [self] in
            saveButton.frame = saveButton.frame.offsetBy(dx: 0, dy: -100)
            dismissButton.frame = dismissButton.frame.offsetBy(dx: 0, dy: 100)
        }
    }

    fileprivate func setupLayout() {        
        view.addSubview(imageView)
        view.addSubview(dismissButton)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 32),
            dismissButton.heightAnchor.constraint(equalToConstant: 32),
            
            saveButton.widthAnchor.constraint(equalToConstant: 66),
            saveButton.heightAnchor.constraint(equalToConstant: 66),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    fileprivate func fillUI() {
        viewModel!.imageBind = { image in
            self.imageView.image = image
        }
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveImage() {
        viewModel?.writeToPhotos(image: imageView.image!)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.saveButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.saveButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
