//
//  Photo.swift
//  Stuffy
//
//  Created by John Hancock on 7/5/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Photo {
    
    let itemPhotoData: Data?
    var itemPhoto: UIImage? {
        guard let data = itemPhotoData,
            let picture = UIImage(data: data) else { return nil }
        return picture
    }
    
    var ckRecordID: CKRecordID?
    let itemReference: CKReference
    let photoReference: String
    
    fileprivate var temporaryItemPhotoURL: URL {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        try? itemPhotoData?.write(to: fileURL, options: [.atomic])
        return fileURL
    }
    
    init(itemPhoto: Data, itemReference: CKReference, photoReference: String = UUID().uuidString) {
        self.itemPhotoData = itemPhoto
        self.itemReference = itemReference
        self.photoReference = photoReference
    }
    
    init?(photoRecord: CKRecord) {
        guard let itemPhoto = photoRecord["itemPhoto"] as? CKAsset,
            let itemReference = photoRecord["itemReference"] as? CKReference,
            let photoReference = photoRecord["photoReference"] as? String
            else { return nil }
        
        let itemPhotoDataContents = try? Data(contentsOf: itemPhoto.fileURL)
        
        self.itemPhotoData = itemPhotoDataContents
        self.itemReference = itemReference
        self.photoReference = photoReference
    }
}

extension CKRecord {
    
    convenience init(photo: Photo) {
        let recordID = photo.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        let photoAsset = CKAsset(fileURL: photo.temporaryItemPhotoURL)
        
        self.init(recordType: "Photo", recordID: recordID)
        
        self.setValue(photoAsset, forKey: "itemPhoto")
        self.setValue(photo.itemReference, forKey: "itemReference")
    }
}
