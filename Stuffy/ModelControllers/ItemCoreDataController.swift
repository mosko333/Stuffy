//
//  ItemCoreDataController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import UIKit

class ItemCoreDataController {
    
    static let shared = ItemCoreDataController()
    
    func createItem(category: String, title: String, receipt: Data,  image: Data, isFavorited: Bool, lastDayToReturn: Date, modelNumber: String, notes: String, price: Double, purchasedFrom: String, quantity: Double, serialNumber: String, warranty: String, purchaseDate: Date ) {
        
        _ = ItemCD(category: category, title: title, image: image, isFavorited: isFavorited, modelNumber: modelNumber, notes: notes, price: price, purchasedFrom: purchasedFrom, quantity: quantity, serialNumber: serialNumber, warranty: warranty, receipt: receipt, purchaseDate: purchaseDate, lastDayToReturn: lastDayToReturn)
        
        CoreDataStack.saveContext()
    }
    
    func removeItem(with item: ItemCD) {
        CoreDataStack.context.delete(item)
        CoreDataStack.saveContext()
    }
    
}
