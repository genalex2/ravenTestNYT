//
//  ravenTestNYTApp.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import SwiftUI

@main
struct ravenTestNYTApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ArticleListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
