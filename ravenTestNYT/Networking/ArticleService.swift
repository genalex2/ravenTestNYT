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
    private let apiKey: String
    private let baseURL: String
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        // Carga las variables de entorno
        self.apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
        self.baseURL = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""
        
        // Verifica que las claves no estén vacías
        guard !apiKey.isEmpty, !baseURL.isEmpty else {
            fatalError("API_KEY o BASE_URL no configurados en variables de entorno.")
        }
        
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
            return "service.desc.invalidURL".localized()
        case .invalidPeriod:
            return "service.desc.invalidPeriod".localized()
        case .invalidResponse:
            return "service.desc.invalidResponse".localized()
        case .httpError(let statusCode):
            return "service.desc.httpError".localized(formatArgs: statusCode)
        case .decodingError(let error):
            return "service.desc.decodingError".localized(formatArgs: error.localizedDescription)
        case .networkError(let error):
            return "service.desc.networkError".localized(formatArgs: error.localizedDescription)
        case .unknown(let error):
            return "service.desc.unknown".localized(formatArgs: error.localizedDescription)
        }
    }
}
