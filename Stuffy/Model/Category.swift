//
//  Category.swift
//  Stuffy
//
//  Created by John Hancock on 7/5/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Category {
    
    var categoryName: String
    var items: [Item]
    
    var ckRecordID: CKRecordID?
    var categoryReference: String = UUID().uuidString
    
    init(categoryName: String, items: [Item] = []) {
        self.categoryName = categoryName
        self.items = items
    }
    
    init?(categoryRecord: CKRecord, items: [Item] = []) {
        guard let categoryName = categoryRecord["categoryName"] as? String,
            let categoryReference = categoryRecord["categoryReference"] as? String
            else { return nil }
        
        self.categoryName = categoryName
        self.items = items
        self.categoryReference = categoryReference
    }
}

extension CKRecord {
    convenience init(category: Category) {
        let recordID = category.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: "Category", recordID: recordID)
        
        self.setValue(category.categoryName, forKey: "categoryName")
        self.setValue(category.categoryReference, forKey: "categoryReference")
    }
}
