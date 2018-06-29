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
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    func createItem(itemName: String, itemPhoto: UIImage, category: String, quantity: Double?, notes: String?, dateOfPurchase: Date?, lastDayOfReturn: Date?, purchasePrice: Double?, serialNo: String?, storeVendor: String?, documentPhoto: UIImage?, documentDescription: String?, isFavorited: Bool?, completion: @escaping ((_ success: Bool) -> Void)) {
        
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("Error creating new item: \(error.localizedDescription)")
            }
            
            guard let recordID = recordID else { return }
            guard let docPhoto = documentPhoto else { return }
            let appleUserRef = CKReference(recordID: recordID, action: CKReferenceAction.deleteSelf)
            guard let itemPhotoData = UIImageJPEGRepresentation(itemPhoto, 1),
                let docPhotoData = UIImageJPEGRepresentation(docPhoto, 1) else { return }
            
            let item = Item(itemName: itemName, category: category, quantity: quantity, notes: notes, dateOfPurchase: dateOfPurchase, lastDayOfReturn: lastDayOfReturn, purchasePrice: purchasePrice, serialNo: serialNo, storeVendor: storeVendor, documentDescription: documentDescription, isFavorited: isFavorited, itemPhoto: itemPhotoData, documentPhoto: docPhotoData, appleUserReference: appleUserRef)
            
            let itemRecord = CKRecord(user: item)
            
            CloudKitManager.shared.saveRecord(itemRecord, completion: { (record, error) in
                if let error = error {
                    print("Error saving new item to cloud: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let record = record, let currentItem = Item(ckRecord: record) else { completion(false) ; return }
                self.items.append(currentItem)
                completion(true)
                return
            })
        }
    }
}
