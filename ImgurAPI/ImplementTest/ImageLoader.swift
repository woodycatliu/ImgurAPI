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
    static let shared: ImageLoader = ImageLoader()
}

extension ImageLoader: LoadImageHandler {
 
    func loadImage(from url: URL) -> AnyPublisher<(Image, URL), Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.global())
            .map { (data, response) -> Image? in return Image(data: data) }
            .catch { error in return Just(nil) }
            .compactMap { $0 }
            .map { ($0, url) }
            .print("Image loading \(url):")
            .eraseToAnyPublisher()
    }
    
    
}
