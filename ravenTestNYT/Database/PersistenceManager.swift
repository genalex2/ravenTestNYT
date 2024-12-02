//
//  PersistenceManager.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 01/12/24.
//

import CoreData

class PersistenceManager {
    static let shared = PersistenceManager()

    private let context: NSManagedObjectContext

    private init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
    }

    func fetchArticles() throws -> [Article] {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        let entities = try context.fetch(fetchRequest)
        return entities.map { $0.toArticle() }
    }

    func saveArticles(_ articles: [Article]) throws {
        for article in articles {
            let entity = ArticleEntity(context: context)
            entity.id = Int64(article.id)
            entity.title = article.title
            entity.abstract = article.abstract
            entity.publishedDate = article.publishedDate
            entity.url = article.url
            entity.byline = article.byline
        }
        if context.hasChanges {
            try context.save()
        }
    }
}

extension ArticleEntity {
    func toArticle() -> Article {
        return Article(
            id: Int(id),
            title: title ?? "",
            abstract: abstract ?? "",
            publishedDate: publishedDate ?? "",
            url: url ?? "",
            byline: byline ?? "",
            media: [])
    }
}
