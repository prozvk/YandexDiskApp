//
//  SupplementaryView.swift
//  YandexDiskRelease
//
//  Created by MacPro on 22.07.2022.
//

import UIKit

class TitleSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    
    let sectionName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont(name: "Montserrat-Bold", size: 22)
        return label
    }()
    let allButton: UIButton = {
        let button = UIButton()
        button.setTitle("См. все", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Light", size: 18)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6755829632, green: 0.6755829632, blue: 0.6755829632, alpha: 1), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

extension TitleSupplementaryView {
    func configure() {
        addSubview(sectionName)
        addSubview(allButton)

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            allButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            allButton.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            allButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            allButton.widthAnchor.constraint(equalToConstant: 100),
            
            sectionName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            sectionName.trailingAnchor.constraint(equalTo: allButton.leadingAnchor, constant: -inset),
            sectionName.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            sectionName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}
