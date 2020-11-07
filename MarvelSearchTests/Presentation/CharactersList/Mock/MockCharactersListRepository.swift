//
//  MockCharactersListRepository.swift
//  MarvelSearchTests
//
//  Created by Everton Gonçalves on 07/11/20.
//

import Foundation

@testable import MarvelSearch

class MockCharactersListRepository: CharactersListRepository {
    
    var returnWithError = false
    
    func search(by name: String, offset: Int, completion: @escaping ([Character]?, Error?) -> ()) {
        
        if returnWithError {
            let error = NSError(domain: "Something went wrong", code: -1, userInfo: nil)
            completion(nil, error)
        }else{
            completion(getMockedCharacters(), nil)
        }
        
    }
    
    private func getMockedCharacters() -> [Character] {
        
        var characters = [Character]()
        
        characters.append(.init(id: 1, name: "Name 1", description: "Description 1", imageUrl: "image 1"))
        characters.append(.init(id: 2, name: "Name ", description: "Description 2", imageUrl: "image 2"))
        characters.append(.init(id: 3, name: "Name 3", description: "Description 3", imageUrl: "image 3"))
        
        return characters
    }
    
}
