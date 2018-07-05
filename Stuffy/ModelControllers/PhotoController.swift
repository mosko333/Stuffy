//
//  PhotoController.swift
//  Stuffy
//
//  Created by John Hancock on 7/5/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class PhotoController {
    
    static let shared = PhotoController()
    
    var photos = [Photo]()
    
    func createPhoto(with item: Item, image: UIImage, completion: @escaping ((_ success: Bool) -> Void)) {
        
        guard let data = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        guard let ckRecordID = item.ckID else { return }
        
        let itemReference = CKReference(recordID: ckRecordID, action: CKReferenceAction.deleteSelf)
        
        let photo = Photo(itemPhoto: data, itemReference: itemReference)
        
        let photoRecord =  CKRecord(photo: photo)
        
        CKContainer.default().privateCloudDatabase.save(photoRecord) { (record, error) in
            if let error = error {
                print("Error saving photo to cloud: \(error.localizedDescription)")
            }
            
            guard let record = record, let newPhoto = Photo(photoRecord: record) else { completion(false) ; return }
            self.photos.append(newPhoto)
            completion(true)
            return
        }
    }
    
    
    func fetchPhoto(item: Item, completion: @escaping ((_ success: Bool) -> Void)) {
        guard let itemID = item.ckID else { return }
        let itemReference = CKReference(recordID: itemID, action: CKReferenceAction.deleteSelf)
        let predicate = NSPredicate(format: "itemReference == %@", itemReference)
        let query = CKQuery(recordType: "Photo", predicate: predicate)
        
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching photos from cloud: \(error.localizedDescription)")
                completion(false)
            }
            
            guard let records = records else { completion(false) ; return }
            self.photos = records.compactMap { Photo(photoRecord: $0)}
            
            completion(true)
        }
    }
}
