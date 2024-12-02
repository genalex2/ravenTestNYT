//
//  PersistenceController.swift
//  ravenTestNYT
//  Centralized Core Data stack for managing persistent storage.
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController() // Singleton instance for shared access.
    
    let container: NSPersistentContainer
    
    /// Initializes the Core Data stack.
    /// - Parameter inMemory: A flag indicating whether to use an in-memory store (useful for testing).
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ArticleModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    /// The main view context for UI-related operations.
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    /// Creates a new background context for long-running operations.
    /// - Returns: A new NSManagedObjectContext configured for background execution.
    func newBackgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }
}
