//
//  ArticleService.swift
//  ravenTestNYT
//  Handles network requests to fetch articles from the API.
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import Foundation
import Combine

// MARK: - ArticleServiceProtocol
protocol ArticleServiceProtocol {
    /// Fetches the most popular articles for a given period.
    /// - Parameter period: The number of days to fetch data for.
    /// - Returns: A publisher emitting an array of articles or an error.
    func fetchPopularArticles(period: Int) -> AnyPublisher<[Article], ArticleServiceError>
}

// MARK: - ArticleService
class ArticleService: ArticleServiceProtocol {
    private let apiKey: String
    private let baseURL: String
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
        self.baseURL = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""
        
        guard !apiKey.isEmpty, !baseURL.isEmpty else {
            fatalError("API_KEY o BASE_URL no configurados en variables de entorno.")
        }
        
        self.session = session
    }
    
    /// Fetches popular articles from the network.
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
        
        NSLog("Generated URL: \(url)")
        
        // Make the network request
        return session.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                NSLog("Received response: \(output.response)")
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
                if let urlError = error as? URLError {
                    return .networkError(urlError)
                } else if let decodingError = error as? DecodingError {
                    return .decodingError(decodingError)
                } else if let serviceError = error as? ArticleServiceError {
                    return serviceError
                } else {
                    return .unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
