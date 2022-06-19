//
//  ViewModel.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/19.
//

import Foundation
import Combine

protocol CollectionViewModelProtocol {
    var numbersOfSection: Int { get }
    func numberOfRowsInSection(_ section: Int)-> Int
    func dataModelFoRowAt(_ indexPath: IndexPath)-> GalleryImage
}

class ViewModel {
    
    private var bag = Set<AnyCancellable>()
    @Published
    private(set) var images: [GalleryImage]?
    
    @Published
    private(set) var style: CollectionViewStyle = .list
    
    let useCase: ExcuteUseCase
    
    private let loader: ImgurAPI = ImgurAPI()
    
    init(_ useCase: ExcuteUseCase) {
        self.useCase = useCase
        binding()
    }
    
    @Published
    private(set) var fetchStatus: FetchStatus = .fetchIng(.one)
    
    private func binding() {
        $fetchStatus
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] in
                self?.fetchNextPage($0)
            })
            .store(in: &bag)
    }
    
}

extension ViewModel: CollectionViewModelProtocol {
    
    
    var numbersOfSection: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func dataModelFoRowAt(_ indexPath: IndexPath) -> GalleryImage {
        guard let images = images,
              images.indices.contains(indexPath.row) else {
                  fatalError("images is out of range")
              }
        return images[indexPath.row]
    }
    
}

extension ViewModel {
    
    func fetchFirstPage() {
        fetchStatus = .wantFetch(.one)
    }
    
    func togleStyle() {
        style = useCase.nextStyle(style)
    }
    
    func nextPage() {
        fetchStatus = useCase.nextPage(fetchStatus)
    }
    
    func fetchNextPage(_ status: FetchStatus) {
        if case let FetchStatus.wantFetch(page) = status {
            fetchStatus = .fetchIng(page)
            useCase.fetchImage(loader: loader, page.rawValue)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [weak self] in
                    if case Subscribers.Completion<Error>.failure = $0 {
                        self?.fetchStatus.failure()
                        return
                    }
                }, receiveValue: { [weak self] imgs in
                    guard let self = self else { return }
                    self.fetchStatus.success()
                    if self.images == nil {
                        self.images = imgs
                        return
                    }
                    self.images?.append(contentsOf: imgs ?? [])
                }).store(in: &bag)
        }
    }
    
}
 
