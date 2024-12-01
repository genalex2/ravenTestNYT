//
//  ArticleDetailView.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NYTDimension.point_16) {
                // Imagen del artículo
                if let imageUrl = article.media.first?.mediaMetadata.last?.url {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: NYTDimension.point_200)
                                .frame(maxWidth: .infinity)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: NYTDimension.point_200)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .cornerRadius(NYTDimension.ten)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: NYTDimension.point_200)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                // Título del artículo
                Text(article.title)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, NYTDimension.four)

                // Información adicional (autor y fecha)
                HStack {
                    if !article.byline.isEmpty {
                        Text(article.byline)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(article.publishedDate)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Divider()

                // Resumen del artículo
                Text(article.abstract)
                    .font(.body)
                    .padding(.bottom, NYTDimension.eight)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("global.details".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailView(article: sampleArticle)
    }
}
