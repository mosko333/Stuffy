//
//  Item+Convince.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import CoreData
extension ItemCoreData {
    
    convenience init(category: String, title: String, image: Data, isFavorited: Bool, modelNumber: Double, notes: String, price: Double, purchasedFrom: String, quantity: Double, serialNumber: Double, warranty: String, documentName: String, documentImage: Data, lastDayToReturn: Date,  context: NSManagedObjectContext = CoreDataStack.context)
    {
        self.init(context: context)
        
        self.category = category
        self.title = title
        self.isFavorite = isFavorited
        self.modelNumber = modelNumber
        self.notes = notes
        self.price = price
        self.purchasedFrom = purchasedFrom
        self.quantity = quantity
        self.serialNumber = serialNumber
        self.warranty = warranty
        self.documentName = documentName
        self.documentImage = documentImage
        self.lastDayToReturn = lastDayToReturn
        
        self.image = image
        
    }
}
