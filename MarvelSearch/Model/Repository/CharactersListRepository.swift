//
//  CharacterListRepository.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 02/11/20.
//

import Foundation

protocol CharactersListRepository {
    func search(by name: String, offset: Int, completion: @escaping ([Character]?, Error?) -> ())
}

final class DefaultCharactersListRepository {
    
    let service: NetworkService
    
    init(service: NetworkService){
        self.service = service
    }
    
}

extension DefaultCharactersListRepository: CharactersListRepository{
    
    func search(by name: String, offset: Int, completion: @escaping ([Character]?, Error?) -> ()) {
        
        let endpoint = APIEnpoints.getCharacters(by: name, offset: offset)
        
        let task = service.request(endpoint: endpoint) { (result) in
            switch result {
            case .success(let response): completion(response.data.toEntity(), nil)
            case .failure(let error): completion(nil, error)
            }
        }
        
        task?.resume()
        
    }
    
}
