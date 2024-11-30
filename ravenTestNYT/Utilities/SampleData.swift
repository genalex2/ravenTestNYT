//
//  SampleData.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import Foundation

// Datos de ejemplo reutilizables
let sampleArticle = Article(
    id: 100000009809091,
    uri: "nyt://article/c5004496-36f6-59c4-8d65-8c95b53fe7ee",
    url: "https://www.nytimes.com/2024/11/28/business/airline-loyalty-programs-rethinking.html",
    source: "New York Times",
    publishedDate: "2024-11-28",
    updated: "2024-11-28 13:46:21",
    section: "Business",
    subsection: nil,
    nytdsection: "business",
    adxKeywords: "Personal Finances;Business Travel;Credit Cards;Customer Loyalty Programs",
    byline: "By Mike Dang",
    type: "Article",
    title: "Frequent Fliers Are Rethinking Loyalty Programs and Setting Themselves Free",
    abstract: "Some travelers, frustrated with changing airline rewards programs, have stopped chasing status and adopted different strategies when booking flights and using credit cards.",
    desFacet: ["Personal Finances", "Business Travel"],
    orgFacet: ["Delta Air Lines Inc", "American Airlines"],
    perFacet: [],
    geoFacet: [],
    media: [
        Media(
            type: "image",
            subtype: "photo",
            caption: "",
            copyright: "Photo Illustration by Ben Denzer",
            approvedForSyndication: 1,
            mediaMetadata: [
                MediaMetadata(
                    url: "https://static01.nyt.com/images/2024/11/30/business/00airline-loyalty/00airline-loyalty-thumbStandard.jpg",
                    format: "Standard Thumbnail",
                    height: 75,
                    width: 75
                )
            ]
        )
    ]
)
