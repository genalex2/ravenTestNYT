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
    let title: String
    let abstract: String
    let publishedDate: String
    let url: String
    let byline: String
    let media: [Media]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case abstract
        case publishedDate = "published_date"
        case url
        case byline
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
