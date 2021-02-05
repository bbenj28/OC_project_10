//
//  FakeCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Benjamin Breton on 03/02/2021.
//

import Foundation
import CoreData
import Reciplease
class FakeCoreDataStack: CoreDataStack {
    override init() {
        super.init()
        // create new description with an InMemoryStoreType
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        // create new container
        let container = NSPersistentContainer(name: "Reciplease")
        // set new description to new container's persistentStoreDescriptions
        container.persistentStoreDescriptions = [persistentStoreDescription]
        // load persistent stores
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        // set new container to self.persistentContainer
        self.persistentContainer = container
    }
}
