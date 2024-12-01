//
//  ArticleListView.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import SwiftUI

struct ArticleListView: View {
    @StateObject private var viewModel = ArticleListViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("global.loading".localized())
                        .scaleEffect(NYTDimension.point1_5, anchor: .center)
                } else {
                    List(viewModel.articles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            VStack(alignment: .leading) {
                                Text(article.title)
                                    .font(.headline)
                                    .lineLimit(NYTDimension.two)
                                Text(article.byline)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("articles.popular".localized())
            .alert(item: $viewModel.error) { error in
                Alert(
                    title: Text("global.error".localized()),
                    message: Text(error.message),
                    dismissButton: .default(Text("global.ok".localized()))
                )
            }
        }
    }
}

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView()
    }
}
