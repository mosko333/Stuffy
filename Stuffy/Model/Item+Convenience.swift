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
    
    convenience init(title: String, isFavorited: Bool, modelNumber: String, notes: String, price: Double, purchasedFrom: String, quantity: Double, serialNumber: String, warranty: Date,  purchaseDate: Date, lastDayToReturn: Date,  context: NSManagedObjectContext = CoreDataStack.context)
    {
        self.init(context: context)
        
        self.title = title
        self.isFavorited = isFavorited
        self.modelNumber = modelNumber
        self.notes = notes
        self.price = price
        self.purchasedFrom = purchasedFrom
        self.quantity = quantity
        self.serialNumber = serialNumber
        self.warranty = warranty
        self.lastDayToReturn = lastDayToReturn
        self.purchaseDate = purchaseDate
        
        
    }
}
