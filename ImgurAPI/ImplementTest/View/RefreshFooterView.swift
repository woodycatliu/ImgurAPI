//
//  RefreshFooterView.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/20.
//

import UIKit

class RefreshFooterView: UICollectionReusableView {
    let activityView: UIActivityIndicatorView  = UIActivityIndicatorView(style: .large)
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityView.heightAnchor.constraint(equalToConstant: 50)
        ])
        activityView.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
