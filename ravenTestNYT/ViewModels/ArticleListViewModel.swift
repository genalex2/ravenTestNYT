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
    
    init(articleService: ArticleServiceProtocol = ArticleService()) {
        self.articleService = articleService
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
                    print("Received Error: \(error.localizedDescription)") // Debugging log
                    self?.error = ErrorWrapper(message: error.errorDescription ?? "An unexpected error occurred.")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] articles in
                self?.articles = articles
            })
            .store(in: &cancellables)
    }
}
