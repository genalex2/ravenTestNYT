//
//  ArticleServiceError.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 02/12/24.
//

import Foundation

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
