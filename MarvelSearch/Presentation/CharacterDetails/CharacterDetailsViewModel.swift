//
//  CharacterDetailsViewModel.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 01/11/20.
//

import Foundation

protocol CharacterDetailsViewModelInput{
    func getCharacterDetails()
}

protocol CharacterDetailsViewModelOutput {
    var item: Observable<CharactersListViewModelItem> { get }
    var description: Observable<String> { get }
    var error: Observable<String> { get }
}

class CharacterDetailsViewModel: CharacterDetailsViewModelOutput {
    
    var item: Observable<CharactersListViewModelItem>
    var description: Observable<String>
    var error: Observable<String>
    
    private var repository: CharacterDetailsRepository
    
    init(character: CharactersListViewModelItem, repository: CharacterDetailsRepository){
        self.repository = repository
        self.item = Observable<CharactersListViewModelItem>(character)
        self.description = Observable<String>("")
        self.error = Observable<String>("")
    }
    
}

extension CharacterDetailsViewModel: CharacterDetailsViewModelInput {
    
    func getCharacterDetails() {
        repository.getCharacterDescription(item.value.id) { (character, error) in
            
            if let _ = error {
                self.error.accept("Error loading the description")
                return
            }
            
            self.description.accept(character?.description ?? "")
        }
    }
    
}
