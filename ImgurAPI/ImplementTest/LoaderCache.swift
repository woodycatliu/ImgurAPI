//
//  LoaderCache.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/29.
//

import UIKit

protocol LoaderImageCache {
    func save(_ data: UIImage, _ key: NSURL)
    func fetch(_ key: NSURL)-> UIImage?
    func remove(_ key: NSURL)
    func removeAll()
}


class ImagesCache: LoaderImageCache {
    
    private let lock: NSLock = NSLock()
    
    private var cache: NSCache<NSURL, UIImage> = .init()
    
    init(_ maxCount: Int = 500) {
        cache.countLimit = maxCount
    }
    
    func fetch(_ key: NSURL) -> UIImage? {
        let image = cache.object(forKey: key)
        return image
    }
    
    func remove(_ key: NSURL) {
        defer {
            lock.unlock()
        }
        lock.lock()
        cache.removeObject(forKey: key)
    }
    
    func save(_ data: UIImage, _ key: NSURL) {
        defer {
            lock.unlock()
        }
        lock.lock()
        cache.setObject(data, forKey: key)
    }
    
    func removeAll() {
        defer {
            lock.unlock()
        }
        lock.lock()
        cache.removeAllObjects()
    }
}
