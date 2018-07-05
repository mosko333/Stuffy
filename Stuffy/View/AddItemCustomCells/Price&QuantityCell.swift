//
//  Price&QuantityCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/26/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

protocol QuantityChangeDelegate: class  {
    func addOneToItemQuantity(_ cell: Price_QuantityCell)
    func minusOneToItemQuantity(_ cell: Price_QuantityCell)
    
}

class Price_QuantityCell: UITableViewCell {

    @IBOutlet weak var priceTextView: UITextView!
    @IBOutlet weak var quantityTextView: UITextView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    weak var delegate: QuantityChangeDelegate?
    
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        delegate?.minusOneToItemQuantity(self)
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        delegate?.addOneToItemQuantity(self)
    }
}
