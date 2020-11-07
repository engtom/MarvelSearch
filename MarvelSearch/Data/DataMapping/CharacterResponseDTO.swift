//
//  CharacterDTO.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 02/11/20.
//

import Foundation

struct CharacterResponseDTO {
    var id: Int
    var name: String
    var description: String
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey{
        case id, name, description, thumbnail
    }
    
    enum Thumbnail: String, CodingKey{
        case path
        case ext = "extension"
    }
}

extension CharacterResponseDTO: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        
        guard let thumbnailValues = try? values.nestedContainer(keyedBy: Thumbnail.self, forKey: .thumbnail) else {
            imageUrl = ""
            return
        }
        
        if let path = try? thumbnailValues.decode(String.self, forKey: .path), let ext = try? thumbnailValues.decode(String.self, forKey: .ext){
            imageUrl = "\(path).\(ext)"
        }else{
            imageUrl = ""
        }
    }
    
}


extension CharacterResponseDTO {
    func toEntity() -> Character {
        return Character(id: id, name: name, description: description, imageUrl: imageUrl)
    }
}
