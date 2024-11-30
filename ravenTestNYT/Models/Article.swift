//
//  Article.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import Foundation

struct ArticlesResponse: Codable {
    let status: String
    let copyright: String
    let numResults: Int
    let results: [Article]

    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case numResults = "num_results"
        case results
    }
}

struct Article: Identifiable, Codable {
    let id: Int
    let uri: String
    let url: String
    let source: String
    let publishedDate: String
    let updated: String
    let section: String
    let subsection: String?
    let nytdsection: String
    let adxKeywords: String
    let byline: String
    let type: String
    let title: String
    let abstract: String
    let desFacet: [String]?
    let orgFacet: [String]?
    let perFacet: [String]?
    let geoFacet: [String]?
    let media: [Media]

    enum CodingKeys: String, CodingKey {
        case id
        case uri
        case url
        case source
        case publishedDate = "published_date"
        case updated
        case section
        case subsection
        case nytdsection
        case adxKeywords = "adx_keywords"
        case byline
        case type
        case title
        case abstract
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case media
    }
}

struct Media: Codable {
    let type: String
    let subtype: String?
    let caption: String?
    let copyright: String?
    let approvedForSyndication: Int
    let mediaMetadata: [MediaMetadata]

    enum CodingKeys: String, CodingKey {
        case type
        case subtype
        case caption
        case copyright
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetadata = "media-metadata"
    }
}

struct MediaMetadata: Codable {
    let url: String
    let format: String
    let height: Int
    let width: Int
}
