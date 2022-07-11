//
//  CellViewModel.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/20.
//

import Foundation
import Combine

protocol CellViewModel {
    var  imageData: PassthroughSubject<Image, Never> { get }
    func didSelected()-> AnyPublisher<CameraListContainer, Never>?
}
 
class ImageCellViewModel: CellViewModel {
    
    private var loadTask: AnyCancellable?
    
    let loader: ImageLoader
    
    init(loader: ImageLoader = ImageLoader.shared) {
        self.loader = loader
    }
    
    let imageData: PassthroughSubject<Image, Never> = PassthroughSubject()

    
    var imageContainer: ImageContainer? {
        didSet {
            if let gi = imageContainer {
                self.loadImage(from: gi)
            }
        }
    }
    
    func loadImage(from gallertImage: ImageContainer) {
        guard let url = URL(string: gallertImage.link) else {
            return
        }
        loadTask?.cancel()

        loadTask = loader.loadImage(from: url)
            .filter { $0.1.absoluteString == gallertImage.link }
            .map { $0.0 }
            .sink(receiveValue: imageData.send)
    }
    
    func didSelected()-> AnyPublisher<CameraListContainer, Never>? {
        if let ad = imageContainer as? ADDataModel {
            print("It's AD Model: ", ad.vendor)
            return Just(.init(type: .ad, info: ad)).print("It's ad").eraseToAnyPublisher()
        }
        if let ci = imageContainer as? CameraInfo {
            return Just(.init(type: .camera, info: ci)).print("It's Camera").eraseToAnyPublisher()
        }
        return nil
    }
    

}
