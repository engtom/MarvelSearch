//
//  ImageLoader.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 02/11/20.
//

import Foundation
import UIKit

struct ImageLoader {
    
    private static let cache = ImageCache()
    
    func loadImage(from url: String, completion: @escaping (UIImage?) -> ()){
        
        if let image = ImageLoader.cache.getImage(withKey: url) {
            completion(image)
            return
        }
        
        guard let request = URL(string: url), UIApplication.shared.canOpenURL(request) else{
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
                
            if let imageToCache = UIImage(data: data) {
                ImageLoader.cache[url] = imageToCache
                completion(imageToCache)
                return
            }
            
            completion(nil)
        }
        
        task.resume()
        
    }
}
