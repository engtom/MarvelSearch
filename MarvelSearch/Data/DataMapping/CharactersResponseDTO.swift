//
//  CharacterDTO.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 02/11/20.
//

import Foundation

struct CharactersResponseDTO: Decodable {
    var code: Int
    var status: String
    var data: DataResponseDTO
    
}
