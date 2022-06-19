//
//  CellViewModel.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/20.
//

import Foundation
import Combine

class CellViewModel {
    
    private var loadTask: AnyCancellable?
    
    let loader: ImageLoader
    
    init(loader: ImageLoader = ImageLoader.shared) {
        self.loader = loader
    }
    
    let imageData: PassthroughSubject<Image, Never> = PassthroughSubject()

    
    var gallertImage: GalleryImage? {
        didSet {
            if let gi = gallertImage {
                self.loadImage(from: gi)
            }
        }
    }
    
    func loadImage(from gallertImage: GalleryImage) {
        guard let url = URL(string: gallertImage.link) else {
            return
        }
        loadTask?.cancel()

        loadTask = loader.loadImage(from: url)
            .receive(on: RunLoop.main)
            .filter { $0.1.absoluteString == gallertImage.link }
            .map { $0.0 }
            .sink(receiveValue: imageData.send)
    }

}
