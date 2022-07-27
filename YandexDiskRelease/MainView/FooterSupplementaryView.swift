//
//  FooterSupplementaryView.swift
//  YandexDiskRelease
//
//  Created by MacPro on 26.07.2022.
//

import UIKit

class FooterSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "footer-supplementary-reuse-identifier"
    
    let photosNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont(name: "Montserrat-Bold", size: 17)
        label.textColor = .systemGray
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let actInd = UIActivityIndicatorView()
        actInd.translatesAutoresizingMaskIntoConstraints = false
        actInd.hidesWhenStopped = true
        //actInd.startAnimating()
        return actInd
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension FooterSupplementaryView {
    func configure() {
        addSubview(photosNumberLabel)
        addSubview(activityIndicator)


        NSLayoutConstraint.activate([
            photosNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            photosNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}

