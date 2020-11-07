//
//  ImageCache.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 02/11/20.
//

import Foundation
import UIKit

struct Config {
    let countLimit: Int
    let memoryLimit: Int
    
    static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) //100MB
    
}

final class ImageCache {
    
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        //cache.countLimit = config.countLimit
        return cache
    }()
    
    private let lock = NSLock()
    private let config: Config
    
    init(config: Config = Config.defaultConfig){
        self.config = config
    }
    
    func save(image: UIImage, forKey key: String){
        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(image, forKey: key as AnyObject)
    }
    
    func getImage(withKey key: String) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        return imageCache.object(forKey: key as AnyObject) as? UIImage
    }
    
}

extension ImageCache {
    subscript(_ key: String) -> UIImage? {
        get {
            return getImage(withKey: key)
        }
        set {
            
            guard let image = newValue else { return }
            
            save(image: image, forKey: key)
        }
    }
}

