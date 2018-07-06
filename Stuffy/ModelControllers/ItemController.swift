//
//  ItemController.swift
//  Stuffy
//
//  Created by John Hancock on 6/29/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class ItemController {
    
    static let shared = ItemController()
    
    var items = [Item]()
    
    func createItem(in category: Category, itemName: String, quantity: Double?, notes: String?, warrantyExpiration: Date?, dateOfPurchase: Date?, lastDayOfReturn: Date?, purchasePrice: Double?, serialNo: String?, storeVendor: String?, isFavorited: Bool?, photos: [Photo]?, completion: @escaping ((_ success: Bool) -> Void)) {
        
        guard let ckRecordID = category.ckRecordID else { return }
        
        let categoryReference = CKReference(recordID: ckRecordID, action: CKReferenceAction.deleteSelf)
        
        let item = Item(itemName: itemName, quantity: quantity, notes: notes, warrantyExpiration: warrantyExpiration, dateOfPurchase: dateOfPurchase, lastDayOfReturn: lastDayOfReturn, purchasePrice: purchasePrice, serialNo: serialNo, storeVendor: storeVendor, isFavorited: isFavorited, photos: photos, categoryReference: categoryReference)
        
        let itemRecord = CKRecord(item: item)
        
        CKContainer.default().privateCloudDatabase.save(itemRecord) { (record, error) in
            if let error = error {
                print("Error creating item: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let record = record, let newItem = Item(itemRecord: record) else { completion(false) ; return }
            self.items.append(newItem)
            completion(true)
            return
        }
    }
    
    func fetchItem(category: Category, completion: @escaping ((_ success: Bool) -> Void)) {
        
        guard let categoryID = category.ckRecordID else { return }
        let categoryReference = CKReference(recordID: categoryID, action: CKReferenceAction.deleteSelf)
        let predicate = NSPredicate(format: "categoryReference == %@", categoryReference)
        let query = CKQuery(recordType: "Item", predicate: predicate)
        
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching items: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false) ; return }
            self.items = records.compactMap { Item(itemRecord: $0)}
            
            completion(true)
        }
    }
}
