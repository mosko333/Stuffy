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

class Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
    
    
    var categoryName: String
    var items: [Item]
    var item: Item?
    var isFavorited: Bool?
    
    var ckRecordID: CKRecordID?
    var categoryReference: String = UUID().uuidString
    
    init(categoryName: String, items: [Item] = [], isFavorited: Bool?) {
        self.categoryName = categoryName
        self.items = items
        self.isFavorited = isFavorited
    }
    
    init?(categoryRecord: CKRecord, items: [Item] = []) {
        guard let isFavorited = categoryRecord["isFavorited"] as? Bool,
            let categoryName = categoryRecord["categoryName"] as? String,
            let categoryReference = categoryRecord["categoryReference"] as? String
            else { return nil }
        
        self.categoryName = categoryName
        self.items = items
        self.isFavorited = isFavorited
        self.categoryReference = categoryReference
        self.ckRecordID = categoryRecord.recordID
    }
}

extension CKRecord {
    convenience init(category: Category) {
        let recordID = category.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: "Category", recordID: recordID)
        
        self.setValue(category.isFavorited, forKey: "isFavorited")
        self.setValue(category.categoryName, forKey: "categoryName")
        self.setValue(category.categoryReference, forKey: "categoryReference")
    }
}
