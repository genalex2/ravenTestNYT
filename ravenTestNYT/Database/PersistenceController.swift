//
//  PersistenceController.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    // Inicialización con soporte para modo en memoria (útil para pruebas)
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ArticleModel") // Reemplaza con el nombre de tu modelo Core Data
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // Contexto principal para la UI
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    // Contexto en segundo plano para tareas largas
    func newBackgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }
}
