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
    
    let shared = ItemCoreDataController ()
    
    func createItem(category: String, title: String, date: Date, documentImage: Data, documentName: String, image: Data, isFavorited: Bool, lastDayToReturn: Date, modelNumber: Double, notes: String, price: Double, purchasedFrom: String, quantity: Double, serialNumber: String, warranty: String ) {
        
        _ = ItemCoreData(category: category, title: title, image: image, isFavorited: isFavorited, modelNumber: modelNumber, notes: notes, price: price, purchasedFrom: purchasedFrom, quantity: quantity, serialNumber: serialNumber, warranty: warranty, documentName: documentName, documentImage: documentImage, lastDayToReturn: lastDayToReturn)
        
        CoreDataStack.saveContext()
    }
    
    func removeItem(with item: ItemCoreData) {
        CoreDataStack.context.delete(item)
        CoreDataStack.saveContext()
    }
    
}
