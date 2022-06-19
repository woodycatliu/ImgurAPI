//
//  Cell.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/20.
//

import UIKit
import Combine

class Cell: UICollectionViewCell {
    let imageView = UIImageView()
    private var bag = Set<AnyCancellable>()
    let viewModel = CellViewModel()
    fileprivate func binding() {
        viewModel.imageData
            .map { $0 }
            .assign(to: \.image, on: imageView)
            .store(in: &bag)
    }
    
     func configureUI() {
        contentView.backgroundColor = .yellow
        contentView.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        binding()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ data: GalleryImage) {
        viewModel.gallertImage = data
    }
}
