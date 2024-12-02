//
//  ArticleListViewModel.swift
//  ravenTestNYT
//  The ViewModel managing the article list, including fetching from network and persistence.
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import Foundation
import Combine

class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = [] // The list of articles displayed in the view.
    @Published var error: ErrorWrapper? // Handles and displays errors in the UI.
    @Published var isLoading: Bool = false // Indicates if data is being fetched.

    private var cancellables = Set<AnyCancellable>()
    private let articleService: ArticleServiceProtocol
    let persistenceManager: PersistenceManager

    /// Initializes the ViewModel.
    /// - Parameters:
    ///   - articleService: The service responsible for fetching articles (defaults to ArticleService).
    ///   - persistenceManager: The persistence layer for saving and loading articles.
    init(articleService: ArticleServiceProtocol = ArticleService(),
         persistenceManager: PersistenceManager = PersistenceManager.shared) {
        self.articleService = articleService
        self.persistenceManager = persistenceManager
        fetchArticles()
    }

    /// Fetches articles from the service or loads them from persistence in case of failure.
    func fetchArticles() {
        isLoading = true
        articleService.fetchPopularArticles(period: 7)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.error = ErrorWrapper(message: error.errorDescription ?? "An unexpected error occurred.")
                    self?.loadLocalArticles() // Load from Core Data if the network fails.
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] articles in
                self?.articles = articles
                self?.saveArticlesToLocalDatabase(articles) // Save to Core Data.
            })
            .store(in: &cancellables)
    }

    private func loadLocalArticles() {
        do {
            articles = try persistenceManager.fetchArticles()
        } catch {
            print("Failed to load local articles: \(error)")
        }
    }

    private func saveArticlesToLocalDatabase(_ articles: [Article]) {
        do {
            try persistenceManager.saveArticles(articles)
        } catch {
            print("Failed to save articles: \(error)")
        }
    }
}
