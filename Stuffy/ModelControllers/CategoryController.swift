//
//  CategoryController.swift
//  Stuffy
//
//  Created by John Hancock on 7/5/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import CloudKit

class CategoryController {
    
    static let shared = CategoryController()
    
    var categories = [Category]()
    
    func createCategory(categoryName: String, completion: @escaping ((_ success: Bool)->Void)) {
        
        let category = Category(categoryName: categoryName)
        
        let categoryRecord = CKRecord(category: category)
        
        CKContainer.default().privateCloudDatabase.save(categoryRecord) { (record, error) in
            if let error = error {
                print("Error creating category \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let record = record, let newCategory = Category(categoryRecord: record) else { completion(false) ; return }
            self.categories.append(newCategory)
            completion(true)
            return
        }
    }
    
    func fetchCategory(completion: @escaping ((_ success: Bool) -> Void)) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Category", predicate: predicate)
        
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching categories \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false) ; return }
            self.categories = records.compactMap { Category(categoryRecord: $0)}
            
            completion(true)
        }
    }
}
