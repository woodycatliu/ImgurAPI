//
//  Cell.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/20.
//

import UIKit
import Combine

class Cell: UICollectionViewCell {
    let activityView: UIActivityIndicatorView  = UIActivityIndicatorView(style: .large)
    let imageView = UIImageView()
    private var bag = Set<AnyCancellable>()
    let viewModel = CellViewModel()
    fileprivate func binding() {
        viewModel.imageData
            .map { $0 }
            .assign(to: \.image, on: imageView)
            .store(in: &bag)
        
        imageView.publisher(for: \.image, options: .new)
            .sink(receiveValue: {[weak self] in
                if $0 == nil {
                    self?.activityView.startAnimating()
                    return
                }
                self?.activityView.stopAnimating()
            })
            .store(in: &bag)
    }
    
    func configureUI() {
        contentView.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray5
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        imageView.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)

        ])
        activityView.startAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        binding()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
//        activityView.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ data: GalleryImage) {
        viewModel.gallertImage = data
    }
}
