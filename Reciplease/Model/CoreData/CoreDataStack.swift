//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Benjamin Breton on 19/01/2021.
//

import Foundation
import CoreData
open class CoreDataStack {
    
    // MARK: - Properties
    
    /// Persistent container used to get or set datas.
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    /// Container's context used to get or set datas.
    var viewContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
    // MARK: - Init
    
    /// Added to be overrided by FakeCoreDataStack
    public init() { }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
