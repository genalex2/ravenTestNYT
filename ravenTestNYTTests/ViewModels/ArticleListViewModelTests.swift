//
//  ArticleListViewModelTests.swift
//  ravenTestNYTTests
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import XCTest
import Combine
@testable import ravenTestNYT

final class ArticleListViewModelTests: XCTestCase {
    var viewModel: ArticleListViewModel!
    var articleServiceMock: MockArticleService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        articleServiceMock = MockArticleService()
        viewModel = ArticleListViewModel(articleService: articleServiceMock)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        articleServiceMock = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchArticlesSuccess() {
        articleServiceMock.mockResult = .success(mockArticles)
        
        let expectation = expectation(description: "Articles fetched successfully")
        
        viewModel.$articles
            .dropFirst()
            .sink { articles in
                XCTAssertEqual(articles.count, mockArticles.count)
                XCTAssertEqual(articles.first?.title, mockArticles.first?.title)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchArticles()
        
        waitForExpectations(timeout: 2.0)
    }
    
    func testFetchArticlesFailure() {
        // Configura el mock con un error específico
        let mockError = URLError(.networkConnectionLost) // Error con código -1005
        articleServiceMock.mockResult = .failure(.networkError(mockError))
        
        let expectation = expectation(description: "Error handled correctly")
        
        viewModel.$error
            .dropFirst() // Ignora el valor inicial
            .first() // Observa el primer cambio
            .sink { errorWrapper in
                XCTAssertNotNil(errorWrapper, "ErrorWrapper debería no ser nil")
                
                // Verifica que el mensaje contiene el prefijo esperado
                let expectedPrefix = "Network error occurred. Error:"
                XCTAssertTrue(
                    errorWrapper?.message.starts(with: expectedPrefix) ?? false,
                    "El mensaje debería comenzar con el prefijo esperado: \(expectedPrefix)"
                )
                
                // Verifica que el resto del mensaje coincide con el `localizedDescription`
                let actualMessage = errorWrapper?.message.replacingOccurrences(of: "\(expectedPrefix) ", with: "")
                XCTAssertEqual(
                    actualMessage,
                    mockError.localizedDescription,
                    "El mensaje del error debería coincidir con la descripción localizada del error mock."
                )
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchArticles()
        
        waitForExpectations(timeout: 2.0)
    }
    
    func testLoadingState() {
        articleServiceMock.mockResult = .success(mockArticles)
        
        let expectation = expectation(description: "Loading state changes correctly")
        
        var loadingStates: [Bool] = []
        
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
            }
            .store(in: &cancellables)
        
        viewModel.fetchArticles()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(loadingStates, [true, true, false , false])
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
}

// MARK: - Mock ArticleService
class MockArticleService: ArticleServiceProtocol {
    var mockResult: Result<[Article], ArticleServiceError>?
    
    func fetchPopularArticles(period: Int) -> AnyPublisher<[Article], ArticleServiceError> {
        guard let result = mockResult else {
            let mockError = URLError(.networkConnectionLost)
            return Fail(error: .networkError(mockError))
                .eraseToAnyPublisher()
        }
        
        return result.publisher
            .eraseToAnyPublisher()
    }
}
