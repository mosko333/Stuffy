//
//  Notes&SaveCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/26/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

protocol SaveItemDelegate: class {
    func saveItem(_ cell: Notes_SaveCell)
}

class Notes_SaveCell: UITableViewCell {

 
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: SaveItemDelegate?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func saveButton(_ sender: Any) {
        delegate?.saveItem(self)

    }
}
