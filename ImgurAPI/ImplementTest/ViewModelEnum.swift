//
//  ViewModelEnum.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/19.
//

import Foundation

enum CollectionViewStyle: Nextable {
    typealias T = Self
    case list
    case grid
    
    func next() -> T {
        return self == .grid ? CollectionViewStyle.list : CollectionViewStyle.grid
    }
}

enum Pages: Int, Nextable {
    typealias T = Self

    func next() -> T {
        return Pages(rawValue: self.rawValue + 1) ?? .none
    }
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case none = 999
}

enum FetchStatus: Equatable, Nextable {
    typealias T = FetchStatus

    case wantFetch(Pages)
    case fetchIng(Pages)
    case success(Pages)
    case failure(Pages)
    case finished(Pages)
    
    func next() -> T {
        switch self {
        case .wantFetch(let page):
            let next = page.next()
            return  next == .none ? FetchStatus.finished(next) : FetchStatus.fetchIng(next)
        case .success(let page):
            let next = page.next()
            return  next == .none ? FetchStatus.finished(next) : FetchStatus.wantFetch(next)
        case .failure(let page):
            return FetchStatus.wantFetch(page)
        case .fetchIng, .finished:
            return self
        }
    }
    
    var pages: Pages {
        switch self {
        case .wantFetch(let pages):
            return pages
        case .fetchIng(let pages):
            return pages
        case .success(let pages):
            return pages
        case .failure(let pages):
            return pages
        case .finished(let pages):
            return pages
        }
    }
    
    mutating func failure() {
        self = .failure(pages)
    }
    
    mutating func fetching() {
        self = .fetchIng(pages)
    }
    
    mutating func success() {
        self = .success(pages)
    }
}

 
