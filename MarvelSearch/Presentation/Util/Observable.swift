//
//  Observable.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 02/11/20.
//

import Foundation

class Observable<T> {
    
    typealias Callback = (T) -> ()
    
    var value: T {
        didSet {
            callback?(value)
        }
    }
    var callback: Callback?
    
    init(_ value: T){
        self.value = value
    }
    
    func bind(_ callback: Callback?) {
        self.callback = callback
    }
    
    func accept(_ value: T){
        self.value = value
        callback?(value)
    }
    
}
