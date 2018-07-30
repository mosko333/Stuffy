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
    
    // This array holds all the categories
    
    var allCategories: [CategoryCD] = []
    // This array holds all the Items
    
    var items: [ItemCD] = []
    // this array holds photos to be saved for the add item tableViewController
    
    var photos: [UIImage] = [] {
        didSet {
            print ("photo was added to to photos array")
        }
    }
    
    func createItem(category: CategoryCD, photos: [UIImage], title: String, isFavorited: Bool, lastDayToReturn: Date, modelNumber: String, notes: String, price: Double, purchasedFrom: String, quantity: Double, serialNumber: String, warranty: Date, purchaseDate: Date ) {
        
        let item = ItemCD(title: title, isFavorited: isFavorited, modelNumber: modelNumber, notes: notes, price: price, purchasedFrom: purchasedFrom, quantity: quantity, serialNumber: serialNumber, warranty: warranty, purchaseDate: purchaseDate, lastDayToReturn: lastDayToReturn)
        
        item.category = category
        
        createImage(item: item, image: photos)
       
        CoreDataStack.saveContext()
    }
    
    
    func removeItem(with item: ItemCD) {
        
        CoreDataStack.context.delete(item)
    
        CoreDataStack.saveContext()
    }
    
    func createCategory(name: String){
        
        let categoryName = name.trimmingCharacters(in: .whitespaces)
        
      _ = CategoryCD(name: categoryName, isFavorited: false)
        
        CoreDataStack.saveContext()
    }
    
    func deleteCategory(with category: CategoryCD){
        
        CoreDataStack.context.delete(category)
        
        CoreDataStack.saveContext()
    }
    
    func createImage(item: ItemCD, image: [UIImage]){
        for i in image{
            guard let imageData = UIImagePNGRepresentation(i) else {return}
            
            let createdImage = ImageCD(image: imageData, item: item)
            
            createdImage.item = item
        }
    }
    
    func deleteImage(with image: ImageCD){
        
        CoreDataStack.context.delete(image)
        
        CoreDataStack.saveContext()
    }
}
