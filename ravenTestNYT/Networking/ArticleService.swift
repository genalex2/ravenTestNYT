//
//  ArticleService.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import Foundation
import Combine

// MARK: - ArticleServiceProtocol
protocol ArticleServiceProtocol {
    func fetchPopularArticles(period: Int) -> AnyPublisher<[Article], ArticleServiceError>
}

// MARK: - ArticleService
class ArticleService: ArticleServiceProtocol {
    private let apiKey = "qTl6HA9lEk9bHwEMNSrdjRAceMnSqQEZ"
    private let baseURL = "https://api.nytimes.com/svc/mostpopular/v2/emailed"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPopularArticles(period: Int) -> AnyPublisher<[Article], ArticleServiceError> {
        // Validate the period
        guard period > 0 && period <= 30 else {
            return Fail(error: ArticleServiceError.invalidPeriod)
                .eraseToAnyPublisher()
        }
        
        // Construct the URL
        guard var urlComponents = URLComponents(string: "\(baseURL)/\(period).json") else {
            return Fail(error: ArticleServiceError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api-key", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: ArticleServiceError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        print("Generated URL: \(url)")
        
        // Make the network request
        return session.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                print("Received response: \(output.response)")
                guard let response = output.response as? HTTPURLResponse else {
                    throw ArticleServiceError.invalidResponse
                }
                guard (200...299).contains(response.statusCode) else {
                    throw ArticleServiceError.httpError(statusCode: response.statusCode)
                }
                return output.data
            }
            .decode(type: ArticlesResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .mapError { error -> ArticleServiceError in
                print("Error occurred: \(error)")
                if let decodingError = error as? DecodingError {
                    return .decodingError(decodingError)
                } else if let urlError = error as? URLError {
                    return .networkError(urlError)
                } else if let serviceError = error as? ArticleServiceError {
                    return serviceError
                } else {
                    return .unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - ArticleServiceError
enum ArticleServiceError: LocalizedError {
    case invalidURL
    case invalidPeriod
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(DecodingError)
    case networkError(URLError)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid. Please check the API endpoint."
        case .invalidPeriod:
            return "The period must be between 1 and 30 days."
        case .invalidResponse:
            return "The server response was invalid or unexpected."
        case .httpError(let statusCode):
            return "HTTP Error: \(statusCode). Please try again later."
        case .decodingError(let error):
            return "Failed to decode the response. Error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error occurred. Error: \(error.localizedDescription)"
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
