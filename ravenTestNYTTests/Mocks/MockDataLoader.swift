//
//  MockDataLoader.swift
//  ravenTestNYTTests
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import Foundation

struct MockDataLoader {
    static func loadMockJSON(named fileName: String) -> Data? {
        guard let url = Bundle(for: ArticleServiceTests.self).url(forResource: fileName, withExtension: "json") else {
            NSLog("Error: Could not find JSON file \(fileName)")
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
