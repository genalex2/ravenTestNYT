//
//  PersistenceController.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 29/11/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ArticleModel") // Asegúrate de usar el nombre correcto del modelo
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        // Carga de datos de ejemplo en Core Data para previsualización
        let article = ArticleEntity(context: context) // Reemplaza con tu modelo de Core Data
        article.title = "Example Article"
        article.abstract = "This is an example article abstract."
        article.byline = "By Preview Author"
        
        // Convertir Date a String (puedes usar un formato adecuado)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Ajusta el formato si es necesario
        article.publishedDate = formatter.string(from: Date())

        do {
            try context.save()
        } catch {
            fatalError("Failed to save preview data: \(error)")
        }

        return controller
    }()
}
