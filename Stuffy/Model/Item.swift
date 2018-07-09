//
//  Item.swift
//  Stuffy
//
//  Created by John Hancock on 6/28/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
    
    var itemName: String
    var quantity: Double?
    var notes: String?
    var warrantyExpiration: Date?
    var dateOfPurchase: Date?
    var lastDayOfReturn: Date?
    var purchasePrice: Double?
    var serialNo: String?
    var storeVendor: String?
    var isFavorited: Bool?
    var photos: [Photo]?
    
    var ckRecordID: CKRecordID?
    let categoryReference: CKReference
    let itemReference: String
    
    
    
    init(itemName: String, quantity: Double?, notes: String?, warrantyExpiration: Date?, dateOfPurchase: Date?, lastDayOfReturn: Date?, purchasePrice: Double?, serialNo: String?, storeVendor: String?, isFavorited: Bool?, photos: [Photo]? = [], categoryReference: CKReference, itemReference: String = UUID().uuidString) {
        self.itemName = itemName
        self.quantity = quantity
        self.notes = notes
        self.warrantyExpiration = warrantyExpiration
        self.dateOfPurchase = dateOfPurchase
        self.lastDayOfReturn = lastDayOfReturn
        self.purchasePrice = purchasePrice
        self.serialNo = serialNo
        self.storeVendor = storeVendor
        self.photos = photos
        self.isFavorited = isFavorited
        self.categoryReference = categoryReference
        self.itemReference = itemReference
    }
    
    init?(itemRecord: CKRecord) {
        guard let itemName = itemRecord["itemName"] as? String,
            let quantity = itemRecord["quantity"] as? Double,
            let notes = itemRecord["notes"] as? String,
            let warrantyExpiration = itemRecord["warrantyExpiration"] as? Date,
            let dateOfPurchase = itemRecord["dateOfPurchase"] as? Date,
            let lastDayOfReturn = itemRecord["lastDayOfReturn"] as? Date,
            let purchasePrice = itemRecord["purchasePrice"] as? Double,
            let serialNo = itemRecord["serialNo"] as? String,
            let storeVendor = itemRecord["storeVendor"] as? String,
            let isFavorited = itemRecord["isFavorited"] as? Bool,
            let categoryReference = itemRecord["categoryReference"] as? CKReference,
            let itemReference = itemRecord["itemReference"] as? String
            else { return nil }
        
        
        self.itemName = itemName
        self.quantity = quantity
        self.notes = notes
        self.warrantyExpiration = warrantyExpiration
        self.dateOfPurchase = dateOfPurchase
        self.lastDayOfReturn = lastDayOfReturn
        self.purchasePrice = purchasePrice
        self.serialNo = serialNo
        self.storeVendor = storeVendor
        self.isFavorited = isFavorited
        self.categoryReference = categoryReference
        self.itemReference = itemReference
        self.ckRecordID = itemRecord.recordID
        
    }
}

extension CKRecord {
    
    convenience init(item: Item) {
        let recordID = item.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: "Item", recordID: recordID)
        
        self.setValue(item.itemName, forKey: "itemName")
        self.setValue(item.quantity, forKey: "quantity")
        self.setValue(item.notes, forKey: "notes")
        self.setValue(item.warrantyExpiration, forKey: "warrantyExpiration")
        self.setValue(item.dateOfPurchase, forKey: "dateOfPurchase")
        self.setValue(item.lastDayOfReturn, forKey: "lastDayOfReturn")
        self.setValue(item.purchasePrice, forKey: "purchasePrice")
        self.setValue(item.serialNo, forKey: "serialNo")
        self.setValue(item.storeVendor, forKey: "storeVendor")
        self.setValue(item.isFavorited, forKey: "isFavorited")
        self.setValue(item.photos, forKey: "photos")
        self.setValue(item.categoryReference, forKey: "categoryReference")
        self.setValue(item.itemReference, forKey: "itemReference")
    }
}
