//
//  DataResponseDTO.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 02/11/20.
//

import Foundation

struct DataResponseDTO: Decodable {
    var offset: Int
    var limit: Int
    var total: Int
    var count: Int
    var results: [CharacterResponseDTO]
}

extension DataResponseDTO {
    func toEntity() -> [Character] {
        return results.map { $0.toEntity() }
    }
}
