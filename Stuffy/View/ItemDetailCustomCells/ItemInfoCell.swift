//
//  ItemInfoCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/27/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class ItemInfoCell: UITableViewCell {


    @IBOutlet weak var purchaseDateLabel: UILabel!
    @IBOutlet weak var returnByDateLabel: UILabel!
    @IBOutlet weak var warrantyLabel: UILabel!
    @IBOutlet weak var vendorTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var serialTextField: UITextField!
    
    func updateCell(with item: ItemCD?) {
        guard let item = item else { return }
        
        let dateFormatter = DateFormatter()
    
        purchaseDateLabel.text = dateFormatter.string(for: "\(item.purchaseDate ?? Date())") ?? ""
        returnByDateLabel.text = dateFormatter.string(for: "\(item.lastDayToReturn ?? Date())") ?? ""
        warrantyLabel.text = dateFormatter.string(for: "\(item.warranty ?? Date())") ?? ""
        
        vendorTextField.text = item.purchasedFrom
        modelTextField.text = item.modelNumber
        serialTextField.text = item.serialNumber
        
    }
    
    
}
