//
//  MockArticles.swift
//  ravenTestNYTTests
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import Foundation

@testable import ravenTestNYT

let mockArticles = [
    Article(
        id: 1,
        uri: "nyt://article/1",
        url: "https://example.com",
        source: "Mock Source",
        publishedDate: "2024-11-29",
        updated: "",
        section: "Test",
        subsection: nil,
        nytdsection: "",
        adxKeywords: "",
        byline: "Test Author",
        type: "Article",
        title: "Mock Article 1",
        abstract: "",
        desFacet: [],
        orgFacet: [],
        perFacet: [],
        geoFacet: [],
        media: []
    )
]
