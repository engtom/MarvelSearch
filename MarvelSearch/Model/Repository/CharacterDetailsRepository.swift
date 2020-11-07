//
//  CharacterDetailsRepository.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 05/11/20.
//

import Foundation

protocol CharacterDetailsRepository {
    func getCharacterDescription(_ characterId: Int, completion: @escaping (Character?, Error?) -> ())
}

final class DefaultCharacterDetailsRepository{
 
    let service: NetworkService
    
    init(service: NetworkService){
        self.service = service
    }
    
}

extension DefaultCharacterDetailsRepository: CharacterDetailsRepository {
    func getCharacterDescription(_ characterId: Int, completion: @escaping (Character?, Error?) -> ()) {
        
        let endpoint = APIEnpoints.getCharacter(id: characterId)
        
        let task = service.request(endpoint: endpoint) { (result) in
            switch result {
            case .success(let response): completion(response.data.toEntity().first, nil)
            case .failure(let error): completion(nil, error)
            }
        }
        
        task?.resume()
        
    }
}
