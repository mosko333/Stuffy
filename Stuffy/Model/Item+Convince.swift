//
//  Item+Convince.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import CoreData

extension ItemCD {
    
    convenience init(category: String, title: String, image: Data, isFavorited: Bool, modelNumber: String, notes: String, price: Double, purchasedFrom: String, quantity: Double, serialNumber: String, warranty: String, receipt: Data,  purchaseDate: Date, lastDayToReturn: Date,  context: NSManagedObjectContext = CoreDataStack.context)
    {
        self.init(context: context)
        
        self.category = category
        self.title = title
        self.isFavorited = isFavorited
        self.modelNumber = modelNumber
        self.notes = notes
        self.price = price
        self.purchasedFrom = purchasedFrom
        self.quantity = quantity
        self.serialNumber = serialNumber
        self.warranty = warranty
        self.receipt = receipt
        self.lastDayToReturn = lastDayToReturn
        self.purchaseDate = purchaseDate
        self.image = image
        
    }
}
