//
//  MockCharacterDetailsRepository.swift
//  MarvelSearchTests
//
//  Created by Everton Gonçalves on 07/11/20.
//

import Foundation

@testable import MarvelSearch

class MockCharacterDetailsRepository: CharacterDetailsRepository {
    
    var returnWithError = false
    var returnEmptyDescription = false
    
    func getCharacterDescription(_ characterId: Int, completion: @escaping (Character?, Error?) -> ()) {
        
        if returnWithError {
            let error = NSError(domain: "Something went wrong", code: -1, userInfo: nil)
            completion(nil, error)
        }else{
            completion(getMockedCharacter(), nil)
        }
    }
    
    private func getMockedCharacter() -> Character {
        return .init(id: 1, name: "Name 1", description: returnEmptyDescription ? "" : "Description 1", imageUrl: "image 1")
    }
    
}
