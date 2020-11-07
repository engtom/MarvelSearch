//
//  UIView+Extensions.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 05/11/20.
//

import Foundation
import UIKit

extension UIView{
    func edges(to: UIView, top: CGFloat=0, left: CGFloat=0, bottom: CGFloat=0, right: CGFloat=0){
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: to.topAnchor, constant: top),
            self.leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: left),
            self.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: bottom),
            self.trailingAnchor.constraint(equalTo: to.trailingAnchor, constant: right),
        ])
    }
}
