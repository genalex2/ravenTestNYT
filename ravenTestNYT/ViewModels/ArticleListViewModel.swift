//
//  ArticleListViewModel.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import Foundation
import Combine

class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var error: ErrorWrapper?
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let articleService: ArticleServiceProtocol
    let persistenceManager: PersistenceManager
    
    init(articleService: ArticleServiceProtocol = ArticleService(),
         persistenceManager: PersistenceManager = PersistenceManager.shared) {
        self.articleService = articleService
        self.persistenceManager = persistenceManager
        fetchArticles()
    }
    
    func fetchArticles() {
        isLoading = true
        articleService.fetchPopularArticles(period: 7)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.error = ErrorWrapper(message: error.errorDescription ?? "An unexpected error occurred.")
                    self?.loadLocalArticles() // Cargar artículos locales en caso de error
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] articles in
                self?.articles = articles
                self?.saveArticlesToLocalDatabase(articles) // Guardar localmente
            })
            .store(in: &cancellables)
    }
    
    private func loadLocalArticles() {
        do {
            articles = try persistenceManager.fetchArticles()
        } catch {
            NSLog("Failed to load local articles: \(error)")
        }
    }
    
    private func saveArticlesToLocalDatabase(_ articles: [Article]) {
        do {
            try persistenceManager.saveArticles(articles)
        } catch {
            NSLog("Failed to save articles: \(error)")
        }
    }
}
