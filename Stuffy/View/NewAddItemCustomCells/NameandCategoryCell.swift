//
//  NameandCategoryCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/3/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

protocol ChangeQuantityDelegate:class {
    func addItemQuantity(_ cell: NameandCategoryCell)
    func minusItemQuantity(_ cell: NameandCategoryCell)
    func openCategories(_ cell: NameandCategoryCell)
}
class NameandCategoryCell: UITableViewCell {
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    weak var delegate: ChangeQuantityDelegate?
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        delegate?.addItemQuantity(self)
    }
    
    
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        delegate?.minusItemQuantity(self)
    }
    @IBAction func selectCategoryButtonTapped(_ sender: UIButton) {
        delegate?.openCategories(self)
    }
}
