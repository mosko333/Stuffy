//
//  ItemInfoCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/27/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

protocol PickerDelegate: class {
    func showPurchaseDatePicker(_ cell: ItemInfoCell)
    func showReturnDatePicker(_ cell: ItemInfoCell)
    func showWarrantyDatePicker(_ cell: ItemInfoCell)
    func cancelButton(_ cell: ItemInfoCell)
    func saveButton(_ cell: ItemInfoCell)
    func dateChanged(_ cell: ItemInfoCell)
}

class ItemInfoCell: UITableViewCell {

  
    @IBOutlet weak var datePurchasedTextField: UITextField!
    
    @IBOutlet weak var warrantyTextField: UITextField!
    
    @IBOutlet weak var returnByDateTextfield: UITextField!
    
    @IBOutlet weak var vendorTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var serialTextField: UITextField!
    
    @IBOutlet weak var background4Picker: UIView!
    
    @IBOutlet weak var pickerView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var setDateButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var purchaseDateLabel: UILabel!
    
    @IBOutlet weak var warrantyDateLabel: UILabel!
    
    @IBOutlet weak var returnByDateLabel: UILabel!
    weak var delegate: PickerDelegate?
    
    func updateCell(with item: ItemCD?) {
        
        guard let item = item else { return }
        
        let dateFormatter = DateFormatter()
        
        let pD = dateFormatter.string(for: "\(item.purchaseDate ?? Date())") ?? ""
        let rD  = dateFormatter.string(for: "\(item.lastDayToReturn ?? Date())") ?? ""
        let wD  = dateFormatter.string(for: "\(item.warranty ?? Date())") ?? ""
        datePurchasedTextField.text = pD
        warrantyTextField.text = rD
        returnByDateTextfield.text = wD
        
        vendorTextField.text = item.purchasedFrom
        modelTextField.text = item.modelNumber
        serialTextField.text = item.serialNumber
        
    }
    

    @IBAction func purchaseDateButtonTapped(_ sender: Any) {
        delegate?.showPurchaseDatePicker(self)
    }
    
    
    @IBAction func warrantyButtonTapped(_ sender: Any) {
        delegate?.showWarrantyDatePicker(self)
    }
    
    @IBAction func returnDateButtonTapped(_ sender: Any) {
        delegate?.showReturnDatePicker(self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.cancelButton(self)
    }
    
    @IBAction func setDateButtonTapped(_ sender: Any) {
        delegate?.saveButton(self)
    }
    @IBAction func datePickerChanged(_ sender: Any) {
        delegate?.dateChanged(self)
    }
    
    
}
