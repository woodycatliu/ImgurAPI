//
//  UseCase.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/19.
//

import Foundation
import Combine

protocol Nextable {
    associatedtype T
    func next()-> T
}

protocol ExcuteUseCase {
    // 取得下頁
    func nextPage(_ status: FetchStatus)-> FetchStatus
    // 更改 cell layout
    func nextStyle(_ style: CollectionViewStyle)-> CollectionViewStyle
    // 取 image
    func fetchImage(loader: ImgurAPI, _ page: Int)-> AnyPublisher<[GalleryImage]?, Error>
}

 
struct UseCase: ExcuteUseCase {
    func nextStyle(_ style: CollectionViewStyle)-> CollectionViewStyle {
        return style.next()
    }
    
    func nextPage(_ status: FetchStatus)-> FetchStatus {
        return status.next()
    }
    
    func fetchImage(loader: ImgurAPI, _ page: Int) -> AnyPublisher<[GalleryImage]?, Error> {
        return loader.searchGallery(query: "cats", page: page)
            .compactMap { $0?.reduce([GalleryImage](), { return $0 + ($1.images?.filter { $0.isImage } ?? [])}) }
            .eraseToAnyPublisher()
    }
}
