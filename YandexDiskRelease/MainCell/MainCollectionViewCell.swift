//
//  MainCollectionViewCell.swift
//  YandexDiskRelease
//
//  Created by MacPro on 20.07.2022.
//

import UIKit

protocol CollectionViewCellWithImageView {
    var imageView: UIImageView { get }
}

class MainCollectionViewCell: UICollectionViewCell, CollectionViewCellWithImageView {
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "doc.text")
        image.tintColor = #colorLiteral(red: 0.4861351612, green: 0.4896013709, blue: 0.5, alpha: 1)
        image.backgroundColor = .systemGroupedBackground
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont(name: "Montserrat-Bold", size: 17)
        name.text = "25,6 mb"
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var sizeLabel: UILabel = {
        let size = UILabel()
        size.font = UIFont(name: "Montserrat-Light", size: 15)
        size.translatesAutoresizingMaskIntoConstraints = false
        return size
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    func configureLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(sizeLabel)
        let inset = CGFloat(0)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            
            sizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            sizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            sizeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
            //sizeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
            ])
    }
    
    func configure(file: File) {
        nameLabel.text = file.name
        sizeLabel.text = file.size
        imageView.contentMode = .scaleAspectFill
        if file.image != nil {
            imageView.image = file.image
        } else if file.preview != nil {
            imageView.image = file.preview
        } else {
            imageView.contentMode = .center
            imageView.image = UIImage(systemName: "doc.text")
        }
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(systemName: "doc.text")
        imageView.contentMode = .center
        nameLabel.text = ""
        sizeLabel.text = ""
    }
}
