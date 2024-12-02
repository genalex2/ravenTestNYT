//
//  PersistenceManager.swift
//  ravenTestNYT
//  Manages Core Data persistence for the app, including saving and fetching data.
//
//  Created by Genaro Alexis Nuño Valenzuela on 01/12/24.
//

import CoreData

class PersistenceManager {
    static let shared = PersistenceManager() // Singleton instance for app-wide access.

    private let context: NSManagedObjectContext

    /// Initializes the PersistenceManager with a given context.
       /// - Parameter context: The managed object context to use (default is app's view context).
    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
    }

    /// Fetches all articles from Core Data.
       /// - Throws: An error if the fetch request fails.
       /// - Returns: An array of Article objects.
    func fetchArticles() throws -> [Article] {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        let entities = try context.fetch(fetchRequest)
        return entities.map { $0.toArticle() }
    }

    /// Saves a list of articles to Core Data.
    /// - Parameter articles: The articles to save.
    /// - Throws: An error if the save operation fails.
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
