//
//  CharactersListVCTests.swift
//  MarvelSearchTests
//
//  Created by Everton Gonçalves on 02/11/20.
//

import XCTest

@testable import MarvelSearch

class CharactersListVCTests: XCTestCase {

    var sut: CharactersListVC!
    var viewModel: CharactersListViewModel!
    var repository: MockCharactersListRepository!
    
    override func setUp() {
        repository = MockCharactersListRepository()
        viewModel = CharactersListViewModel(repository: repository)
        sut = CharactersListVC(viewModel: viewModel)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        repository = nil
        viewModel = nil
        super.tearDown()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadingCharacters_SnapshotMustHaveSameCountAsViewModelList() throws {
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.dataSource.snapshot().itemIdentifiers.count, 3)
    }
    
    func testTitle_CheckIfTitleIsCorrect() {
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.navigationItem.title, "Marvel Search")
    }

}
