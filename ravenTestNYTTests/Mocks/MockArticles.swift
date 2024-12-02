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
        id: 100000009809091,
        title: "Frequent Fliers Are Rethinking Loyalty Programs and Setting Themselves Free",
        abstract: "Some travelers, frustrated with changing airline rewards programs, have stopped chasing status and adopted different strategies when booking flights and using credit cards.",
        publishedDate: "2024-11-28",
        url: "https://www.nytimes.com/2024/11/28/business/airline-loyalty-programs-rethinking.html",
        byline: "By Mike Dang",
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
]
