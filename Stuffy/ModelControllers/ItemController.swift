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
    
    func createItem(in category: Category, itemName: String, quantity: Double?, notes: String?, warrantyExpiration: Date?, dateOfPurchase: Date?, lastDayOfReturn: Date?, purchasePrice: Double?, serialNo: String?, storeVendor: String?, isFavorited: Bool?, completion: @escaping ((_ success: Bool) -> Void)) {
        
        guard let ckRecordID = category.ckRecordID else { return }
        
        let categoryReference = CKReference(recordID: ckRecordID, action: CKReferenceAction.deleteSelf)
        
        let item = Item(itemName: itemName, quantity: quantity, notes: notes, warrantyExpiration: warrantyExpiration, dateOfPurchase: dateOfPurchase, lastDayOfReturn: lastDayOfReturn, purchasePrice: purchasePrice, serialNo: serialNo, storeVendor: storeVendor, isFavorited: isFavorited, categoryReference: categoryReference)
        
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
        }
    }
    
    func fetchItems(category: Category, completion: @escaping ((_ success: Bool) -> Void)) {
        
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
            category.items = self.items
            for item in self.items {
                PhotoController.shared.fetchPhoto(item: item, completion: { (success) in
                    if success {
                        print("Successfully fetched photo for \(item.itemName)📷")
                    } else {
                        print("Coulnd't fetch photo for \(item.itemName) 😔")
                    }
                })
            }
            completion(true)
        }
    }
    
    func updateItem(item: Item, itemName: String, quantity: Double?, notes: String?, warrantyExpiration: Date?, dateOfPurchase: Date?, lastDayOfReturn: Date?, purchasePrice: Double?, serialNo: String?, storeVendor: String?, isFavorited: Bool?, completion: @escaping ((_ success: Bool) -> Void)) {
        
        item.itemName = itemName
        item.quantity = quantity ?? item.quantity
        item.notes = notes ?? item.notes
        item.warrantyExpiration = warrantyExpiration ?? item.warrantyExpiration
        item.dateOfPurchase = dateOfPurchase ?? item.dateOfPurchase
        item.lastDayOfReturn = lastDayOfReturn ?? item.lastDayOfReturn
        item.purchasePrice = purchasePrice ?? item.purchasePrice
        item.serialNo = serialNo ?? item.serialNo
        item.storeVendor = storeVendor ?? item.storeVendor
        item.isFavorited = isFavorited ?? item.isFavorited
        
        let record = CKRecord(item: item)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.completionBlock = {
            completion(true)
        }
        CKContainer.default().privateCloudDatabase.add(operation)
    }
    
    
    func deleteItem(with item: Item, completion: @escaping ((_ success: Bool) -> Void)) {
        
        guard let itemID = item.ckRecordID else { return }
        
        CKContainer.default().privateCloudDatabase.delete(withRecordID: itemID) { (_, error) in
            if let error = error {
                print("Error deleting item from cloud: \(error.localizedDescription)")
                completion(false)
            }
            
            guard let indexPath = self.items.index(of: item) else { completion(false) ; return }
            self.items.remove(at: indexPath)
            
            completion(true)
        }
    }
}

