//
//  CoreDataFetchController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/30/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import CoreData

class CoreDataFetchController {
    
   static let shared = CoreDataFetchController()
    
    func fetchAllCategories() -> [CategoryCD]{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryCD")
    
        let results = try? CoreDataStack.context.fetch(fetchRequest)
        
        return results as! [CategoryCD]
    }
    
    func fetchAllItems() -> [ItemCD] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemCD")
        
        let results = try? CoreDataStack.context.fetch(fetchRequest)
        
        return results as! [ItemCD]
    }
}
