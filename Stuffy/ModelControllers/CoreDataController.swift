//
//  ItemCoreDataController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import UIKit

class CoreDataController {
    
    static let shared = CoreDataController()
    
    var items: [ItemCD] = []
    var photos: [UIImage] = [] {
        didSet {
            print ("photo was added to to photos array")
            print(photos.count)
        }
    }
    
    func createItem(category: CategoryCD, title: String, isFavorited: Bool, lastDayToReturn: Date, modelNumber: String, notes: String, price: Double, purchasedFrom: String, quantity: Double, serialNumber: String, warranty: String, purchaseDate: Date ) {
        
        let item = ItemCD(title: title, isFavorited: isFavorited, modelNumber: modelNumber, notes: notes, price: price, purchasedFrom: purchasedFrom, quantity: quantity, serialNumber: serialNumber, warranty: warranty, purchaseDate: purchaseDate, lastDayToReturn: lastDayToReturn)
        
        item.category = category
        
        CoreDataStack.saveContext()
    }
    
    
    func removeItem(with item: ItemCD) {
        
        CoreDataStack.context.delete(item)
    
        CoreDataStack.saveContext()
    }
    
    func createCategory(name: String){
        let categoryName = name.replacingOccurrences(of: " ", with: "")
        
        
      _ = CategoryCD(name: categoryName, isFavorited: false)
        
        CoreDataStack.saveContext()
    }
    
    func deleteCategory(with category: CategoryCD){
        
        CoreDataStack.context.delete(category)
        
        CoreDataStack.saveContext()
    }
    
    func createImage(item: ItemCD, image: UIImage){
        
    guard let imageData = UIImagePNGRepresentation(image) else {return}
        
        let createdImage = ImageCD(image: imageData, item: item)
        
//        createdImage.item = item
        
      CoreDataStack.saveContext()
    }
    
    func deleteImage(with image: ImageCD){
        
        CoreDataStack.context.delete(image)
        
        CoreDataStack.saveContext()
    }
}
