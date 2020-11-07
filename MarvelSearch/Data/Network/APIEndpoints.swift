//
//  APIEndpoints.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 02/11/20.
//

import Foundation

struct APIEnpoints {
    
    static func getCharacters(by name: String, offset: Int) -> Endpoint<CharactersResponseDTO>{
        
        var queryParameters = defaultHeader()
        if !name.isEmpty {
            queryParameters["nameStartsWith"] = name
        }
        queryParameters["offset"] = "\(offset)"
        
        return Endpoint(method: .get, path: "characters", queryParameters: queryParameters)
        
    }
    
    static func getCharacter(id: Int) -> Endpoint<CharactersResponseDTO> {
        
        let queryParameters = defaultHeader()
        
        return Endpoint(method: .get, path: "characters/\(id)", queryParameters: queryParameters)
        
    }
    
    private static func defaultHeader() -> [String: String] {
        let md5Data = "1\(AppConfig().apiPrivatekey)\(AppConfig().apikey)".MD5()
        let md5String = md5Data.map { String(format: "%02hhx", $0) }.joined()
        
        return ["apikey": AppConfig().apikey, "ts": "1", "hash": md5String]
    }
}
