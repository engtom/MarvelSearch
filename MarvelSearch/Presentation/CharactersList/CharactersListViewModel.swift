//
//  CharactersListViewModel.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 01/11/20.
//

import Foundation

struct CharactersListViewModelItem: Hashable {
    var uId = UUID()
    var id: Int
    var imageUrl: String
    var name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uId)
    }
    
    static func == (lhs: CharactersListViewModelItem, rhs: CharactersListViewModelItem) -> Bool {
        return lhs.uId == rhs.uId
    }
}

protocol CharactersListViewModelInput {
    func search(name: String, clean: Bool)
}

protocol CharactersListViewModelOutput{
    var title: String { get }
    var list: Observable<Array<CharactersListViewModelItem>> { get }
    var error: Observable<String> { get }
    var isLoading: Bool { get }
}

class CharactersListViewModel: CharactersListViewModelOutput {
    
    var title: String {
        get {
            return "Marvel Search"
        }
    }
    
    var list = Observable<Array<CharactersListViewModelItem>>([])
    var error = Observable<String>("")
    var isLoading = false
    
    let perPage = 20
    var page = 0
    
    let repository: CharactersListRepository
    
    init(repository: CharactersListRepository) {
        self.repository = repository
    }
    
    private func handleReturn(_ characters: [Character]){
        
        let result = characters.map { CharactersListViewModelItem(id: $0.id,imageUrl: $0.imageUrl, name: $0.name) }
        
        if page == 0 {
            list.accept(result)
        }else{
            let finalArray = list.value + result
            
            list.accept(finalArray)
        }
        
        page += 1
    }
}

extension CharactersListViewModel: CharactersListViewModelInput {
    
    func search(name: String, clean: Bool = false) {
        isLoading = true
        
        if clean { page = 0 }
        let offset = page * perPage
        
        repository.search(by: name, offset: offset) { [unowned self] (characters, error) in
            self.isLoading = false
            if let error = error {
                self.error.accept(error.localizedDescription)
            }else{
                guard let characters = characters else {
                    self.handleReturn([])
                    return
                }
                
                self.handleReturn(characters)
            }
            
        }
    }
    
}
