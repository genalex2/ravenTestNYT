//
//  ArticleServiceTests.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import XCTest
import Combine
@testable import ravenTestNYT

class ArticleServiceTests: XCTestCase {
    var articleService: ArticleService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        MockURLProtocol.responseData = nil
        MockURLProtocol.responseError = nil
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        
        articleService = ArticleService(session: session)
        cancellables = []
    }

    override func tearDown() {
        articleService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchPopularArticlesSuccess() {
        if let data = MockDataLoader.loadMockJSON(named: "ArticleResponseMock") {
            MockURLProtocol.responseData = data
        } else {
            XCTFail("Failed to load mock JSON")
        }
        
        MockURLProtocol.responseError = nil

        let expectation = self.expectation(description: "Fetch articles successfully")
        
        articleService.fetchPopularArticles(period: 7)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Test Error: \(error.localizedDescription)")
                    XCTFail("Expected success, but got error: \(error.localizedDescription)")
                case .finished:
                    print("Test Finished Successfully")
                }
            }, receiveValue: { articles in
                XCTAssertEqual(articles.count, 1)
                XCTAssertEqual(articles.first?.title, "Frequent Fliers Are Rethinking Loyalty Programs and Setting Themselves Free")
                expectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testFetchPopularArticlesFailure() {
        // Simula un error de red
        MockURLProtocol.responseData = nil
        MockURLProtocol.responseError = URLError(.notConnectedToInternet)

        let expectation = self.expectation(description: "Fetch articles fails with network error")

        articleService.fetchPopularArticles(period: 7)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // Verifica que el error sea del tipo esperado
                    if case .networkError(let urlError) = error,
                       urlError.code == .notConnectedToInternet {
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected network error with code .notConnectedToInternet, but got: \(error)")
                    }
                case .finished:
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got articles")
            })
            .store(in: &self.cancellables)

        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
