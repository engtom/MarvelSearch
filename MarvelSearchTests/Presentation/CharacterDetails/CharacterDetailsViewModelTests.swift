//
//  CharacterDetailsViewModelTests.swift
//  MarvelSearchTests
//
//  Created by Everton Gonçalves on 07/11/20.
//

import XCTest

@testable import MarvelSearch

class CharacterDetailsViewModelTests: XCTestCase {

    var sut: CharacterDetailsViewModel!
    var repository: CharacterDetailsRepository!
    
    override func setUp() {
        repository = MockCharacterDetailsRepository()
        sut = CharacterDetailsViewModel(character: .init(id: 1, imageUrl: "image 1", name: "Name 1"), repository: repository)
    }
    
    override func tearDown() {
        sut = nil
        repository = nil
        super.tearDown()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testErrorStartsEmpty_ErrorShouldStartsAsEmptyString() throws {
        XCTAssertEqual(sut.error.value, "")
    }
    
    func testRequest_ShouldReturnACharacter(){
        sut.getCharacterDetails()
        
        XCTAssertEqual(sut.description.value, "Description 1")
    }
    
    func testErrorHandling_ShouldSetErrorProperty(){
        (repository as! MockCharacterDetailsRepository).returnWithError = true
        
        sut.getCharacterDetails()
        
        XCTAssertEqual(sut.error.value, "Error loading the description")
    }

}
