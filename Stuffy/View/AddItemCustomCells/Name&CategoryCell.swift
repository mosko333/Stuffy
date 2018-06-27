//
//  Name&CategoryCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/26/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

protocol addNewCategoryDelegate:class {
    func animateNewCategoryView(_ cell: Name_CategoryCell)
}

class Name_CategoryCell: UITableViewCell {


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var addCategoryButton: UIButton!
    
    weak var delegate: addNewCategoryDelegate?
 
    @IBAction func addNewCategory(_ sender: Any) {
        delegate?.animateNewCategoryView(self)
    }
}
