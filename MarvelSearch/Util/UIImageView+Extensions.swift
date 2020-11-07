//
//  UIImageView+Extensions.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 02/11/20.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFrom(url: String){
     
        ImageLoader().loadImage(from: url) { image in
            DispatchQueue.main.async {
                guard let image = image else {
                
                    self.image = UIImage(named: "gh-logo")
                
                    return
                }
            
                self.image = image
            }
            
        }
        
    }
}
