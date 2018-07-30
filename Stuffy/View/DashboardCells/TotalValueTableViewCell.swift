//
//  TotalValueTableViewCell.swift
//  Stuffy
//
//  Created by Adam on 19/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class TotalValueTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var numberOfCats: UILabel!
    @IBOutlet weak var numberOfItems: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell () {
        let totalPrice = getTotalValue()
        let totalCategories = getTotalAmountofCategories()
        let totalItems = getTotalAmountofItems()
        totalValueLabel.text = "\(totalPrice)"
        numberOfCats.text = "\(totalCategories)"
        numberOfItems.text = "\(totalItems)"
        
    }
    
    func getTotalValue() -> Double {
       let items = CoreDataController.shared.items
        var totalValue: Double = 0
        for item in items {
            var price = item.price
            if item.quantity >= 0 {
                price *= item.quantity
            }
            totalValue += (price)
        }
        return totalValue
    }
    func getTotalAmountofCategories() -> Int {
       return CoreDataController.shared.allCategories.count
    }
    func getTotalAmountofItems() -> Int {
        return CoreDataController.shared.items.count
    }
}
