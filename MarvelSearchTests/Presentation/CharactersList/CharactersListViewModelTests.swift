//
//  CharactersListViewModelTests.swift
//  MarvelSearchTests
//
//  Created by Everton Gonçalves on 02/11/20.
//

import XCTest

@testable import MarvelSearch

class CharactersListViewModelTests: XCTestCase {

    var sut: CharactersListViewModel!
    var repository: CharactersListRepository!
    
    override func setUp() {
        repository = MockCharactersListRepository()
        sut = CharactersListViewModel(repository: repository)
    }
    
    override func tearDown() {
        sut = nil
        repository = nil
        super.tearDown()
    }
    
    func testErrorStartsEmpty_ErrorShouldStartsAsEmptyString() throws {
        XCTAssertEqual(sut.error.value, "")
    }
    
    func testRepositoryCall_ShouldSetListProperty(){
        sut.search(name: "")
        sut.search(name: "")
        
        XCTAssertEqual(sut.list.value.count, 6)
    }
    
    func testRepositoryCallCleaning_ShouldSetListPropertyCleaningPreviousResult(){
        sut.search(name: "")
        sut.search(name: "")
        sut.search(name: "", clean: true)
        
        XCTAssertEqual(sut.list.value.count, 3)
    }
    
    func testErrorHandling_ShouldSetErrorProperty(){
        (repository as! MockCharactersListRepository).returnWithError = true
        
        sut.search(name: "")
        
        XCTAssertNotEqual(sut.error.value, "")
    }

}
