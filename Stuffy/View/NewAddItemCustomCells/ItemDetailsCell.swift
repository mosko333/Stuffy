//
//  ItemDetailsCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/3/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

protocol CustomDatePickerDelegate:class {
    func showPurchaseDatePicker(_ cell: ItemDetailsCell)
    func showReturnDatePicker(_ cell: ItemDetailsCell)
    func showWarrantyDatePicker(_ cell: ItemDetailsCell)
    func cancelButton(_ cell: ItemDetailsCell)
    func saveButton(_ cell: ItemDetailsCell)
    func dateChanged(_ cell: ItemDetailsCell)
}

class ItemDetailsCell: UITableViewCell {
    
    @IBOutlet weak var purchaseDateTextField: UITextField!
    @IBOutlet weak var returnDateTextField: UITextField!
    @IBOutlet weak var warrantyExpirationDateTextField: UITextField!
    @IBOutlet weak var storeVenderTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var serialTextField: UITextField!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var purchaseDateLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var warrantyExpirationDateLabe:UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: CustomDatePickerDelegate?
    
    
    
    @IBAction func purchaseDateButtonTapped(_ sender: UIButton) {
    delegate?.showPurchaseDatePicker(self)
        
    }
    
 
    @IBAction func returnDateButtonTapped(_ sender: Any) {
    delegate?.showReturnDatePicker(self)
    }
    
    @IBAction func warrantyDateButtonTapped(_ sender: Any) {
    delegate?.showWarrantyDatePicker(self)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        delegate?.saveButton(self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        delegate?.cancelButton(self)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        delegate?.dateChanged(self)
        
    }
}
    
    
    
    

