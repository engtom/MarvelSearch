//
//  AppConfig.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 01/11/20.
//

import Foundation

class AppConfig {
    lazy var apikey: String = {
        return "6343db34b45bfd7febee7946cdcd1ae5"
    }()
    
    lazy var apiPrivatekey: String = {
        return "9a60831781cf2faa7051d5462f2089984888413b"
    }()
    
    lazy var baseUrl: String = {
       return "https://gateway.marvel.com:443/v1/public/"
    }()
}
