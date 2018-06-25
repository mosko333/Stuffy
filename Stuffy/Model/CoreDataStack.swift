//
//  CoreDataStack.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static var container: NSPersistentContainer = {
        
        //creating the container
        let container = NSPersistentContainer(name: "Model")
        //load the container
        container.loadPersistentStores(completionHandler: { (discription, error) in
            if let error = error {
                print("Error:")
                fatalError()
            }
        })
        //return the container
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
    static func saveContext() {
        do {
            try context.save()
        } catch  {
            print("Error: \(error.localizedDescription)")
        }
    }
}
