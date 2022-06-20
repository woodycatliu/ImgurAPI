//
//  BigCell.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/20.
//

import UIKit

class BigCell: Cell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray5
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        
        imageView.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)

        ])
        activityView.startAnimating()
    }
}
