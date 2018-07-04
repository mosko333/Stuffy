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

class Item {
    let itemName: String
    let itemPhotoData: Data?
    let category: String
    let quantity: Double?
    let notes: String?
    let dateOfPurchase: Date?
    let lastDayOfReturn: Date?
    let purchasePrice: Double?
    let serialNo: String?
    let storeVendor: String?
    let documentPhotoData: Data?
    let documentDescription: String?
    let isFavorited: Bool?
    var itemPhoto: UIImage? {
        guard let data = itemPhotoData,
            let picture = UIImage(data: data) else { return nil }
        return picture
    }
    
    var documentPhoto: UIImage? {
        guard let data = documentPhotoData,
            let picture = UIImage(data: data) else { return nil }
        return picture
    }
    
    var ckID: CKRecordID?
    let appleUserReference: CKReference
    
    fileprivate var temporaryItemPhotoURL: URL {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        try? itemPhotoData?.write(to: fileURL, options: [.atomic])
        return fileURL
    }
    
    fileprivate var temporaryDocumentPhotoURL: URL {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        try? documentPhotoData?.write(to: fileURL, options: [.atomic])
        return fileURL
        
    }
    
    init(itemName: String, category: String, quantity: Double?, notes: String?, dateOfPurchase: Date?, lastDayOfReturn: Date?, purchasePrice: Double?, serialNo: String?, storeVendor: String?,  documentDescription: String?, isFavorited: Bool?, itemPhoto: Data?, documentPhoto: Data?, appleUserReference: CKReference) {
        self.itemName = itemName
        self.itemPhotoData = itemPhoto
        self.category = category
        self.quantity = quantity
        self.notes = notes
        self.dateOfPurchase = dateOfPurchase
        self.lastDayOfReturn = lastDayOfReturn
        self.purchasePrice = purchasePrice
        self.serialNo = serialNo
        self.storeVendor = storeVendor
        self.documentPhotoData = documentPhoto
        self.documentDescription = documentDescription
        self.isFavorited = isFavorited
        self.appleUserReference = appleUserReference
    }
    
    init?(ckRecord: CKRecord) {
        guard let itemName = ckRecord["itemName"] as? String,
            let itemPhoto = ckRecord["itemPhoto"] as? CKAsset,
            let category = ckRecord["category"] as? String,
            let quantity = ckRecord["quantity"] as? Double,
            let notes = ckRecord["notes"] as? String,
            let dateOfPurchase = ckRecord["dateOfPurchase"] as? Date,
            let lastDayOfReturn = ckRecord["lastDayOfReturn"] as? Date,
            let purchasePrice = ckRecord["purchasePrice"] as? Double,
            let serialNo = ckRecord["serialNo"] as? String,
            let storeVendor = ckRecord["storeVendor"] as? String,
            let documentDescription = ckRecord["documentDescription"] as? String,
            let documentPhoto = ckRecord["documentPhoto"] as? CKAsset,
            let isFavorited = ckRecord["isFavorited"] as? Bool,
            let appleUserReference = ckRecord["appleUserReference"] as? CKReference
            else { return nil }
        
        let itemPictureData = try? Data(contentsOf: itemPhoto.fileURL)
        let documentPictureData = try? Data(contentsOf: documentPhoto.fileURL)
        
        self.itemName = itemName
        self.itemPhotoData = itemPictureData
        self.category = category
        self.quantity = quantity
        self.notes = notes
        self.dateOfPurchase = dateOfPurchase
        self.lastDayOfReturn = lastDayOfReturn
        self.purchasePrice = purchasePrice
        self.serialNo = serialNo
        self.storeVendor = storeVendor
        self.documentDescription = documentDescription
        self.documentPhotoData = documentPictureData
        self.isFavorited = isFavorited
        self.appleUserReference = appleUserReference
        self.ckID = ckRecord.recordID
    }
}

extension CKRecord {
    
    convenience init(user: Item) {
        let recordID = user.ckID ?? CKRecordID(recordName: UUID().uuidString)
        let itemPhotoAsset = CKAsset(fileURL: user.temporaryItemPhotoURL)
        let documentPhotoAsset = CKAsset(fileURL: user.temporaryDocumentPhotoURL)
        
        self.init(recordType: "Item", recordID: recordID)
        
        self.setValue(user.itemName, forKey: "itemName")
        self.setValue(itemPhotoAsset, forKey: "itemPhoto")
        self.setValue(user.category, forKey: "category")
        self.setValue(user.quantity, forKey: "quantity")
        self.setValue(user.notes, forKey: "notes")
        self.setValue(user.dateOfPurchase, forKey: "dateOfPurchase")
        self.setValue(user.lastDayOfReturn, forKey: "lastDayOfReturn")
        self.setValue(user.purchasePrice, forKey: "purchasePrice")
        self.setValue(user.serialNo, forKey: "serialNo")
        self.setValue(user.storeVendor, forKey: "storeVendor")
        self.setValue(user.documentDescription, forKey: "documentDescription")
        self.setValue(documentPhotoAsset, forKey: "documentPhoto")
        self.setValue(user.isFavorited, forKey: "isFavorited")
        self.setValue(user.appleUserReference, forKey: "appleUserReference")
    }
}
