//
//  CharacterDetailsVCTests.swift
//  MarvelSearchTests
//
//  Created by Everton Gonçalves on 07/11/20.
//

import XCTest

@testable import MarvelSearch

class CharacterDetailsVCTests: XCTestCase {

    var sut: CharacterDetailsVC!
    var viewModel: CharacterDetailsViewModel!
    var repository: CharacterDetailsRepository!
    
    override func setUp() {
        repository = MockCharacterDetailsRepository()
        viewModel = CharacterDetailsViewModel(character: .init(id: 1, imageUrl: "Image 1", name: "Name 1"), repository: repository)
        sut = CharacterDetailsVC(viewModel: viewModel)
        sut.loadView()
    }
    
    override func tearDown() {
        sut = nil
        viewModel = nil
        repository = nil
        super.tearDown()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadingDescription_ShouldLoadTheCharactersDescription() throws {
        sut.viewDidLoad()
        
        let exp = expectation(description: "Wait 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1)
        
        if result == .timedOut {
            XCTAssertEqual(sut.textView.text, "Description 1")
        }else{
            XCTFail()
        }
    }
    
    func testErrorLoadingDescription_TextViewShouldPresentErrorMessage() throws {
        (repository as! MockCharacterDetailsRepository).returnWithError = true
        sut.viewDidLoad()
        
        let exp = expectation(description: "Wait 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1)
        
        if result == .timedOut {
            XCTAssertEqual(sut.textView.text, "Error loading the description")
        }else{
            XCTFail()
        }
    }
    
    func testLoadingEmptyDescription_TextViewShouldPresentEmptyDescriptionMessage() throws {
        (repository as! MockCharacterDetailsRepository).returnEmptyDescription = true
        sut.viewDidLoad()
        
        let exp = expectation(description: "Wait 1 second")
        let result = XCTWaiter.wait(for: [exp], timeout: 1)
        
        if result == .timedOut {
            XCTAssertEqual(sut.textView.text, "No description available")
        }else{
            XCTFail()
        }
    }

}
