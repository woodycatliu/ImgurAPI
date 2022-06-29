//
//  ImageLoader.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/20.
//

import UIKit
import Combine

typealias Image = UIImage

protocol LoadImageHandler {
    func loadImage(from url: URL)-> AnyPublisher<(Image, URL), Never>
}

class ImageLoader {
    private var bag = Set<AnyCancellable>()
    static let shared: ImageLoader = ImageLoader()
    
    let loaderCache: LoaderImageCache
    
    init(_ loaderCache:  LoaderImageCache = ImagesCache()) {
        self.loaderCache = loaderCache
    }
}

extension ImageLoader: LoadImageHandler {
 
    func loadImage(from url: URL) -> AnyPublisher<(Image, URL), Never> {
        if let image = loaderCache.fetch(url as NSURL) {
            return Just((image, url)).eraseToAnyPublisher()
        }
        
       let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.global())
            .map { (data, response) -> Image? in return Image(data: data) }
            .catch { error in return Just(nil) }
            .compactMap { $0 }
            .map { ($0, url) }
            .print("Image loading \(url):")
            .share()
        
        publisher
            .sink(receiveValue: { [weak self] image, url in
            self?.loaderCache.save(image, url as NSURL)
        }).store(in: &bag)
        
        return publisher.eraseToAnyPublisher()
    }
    
    
}
