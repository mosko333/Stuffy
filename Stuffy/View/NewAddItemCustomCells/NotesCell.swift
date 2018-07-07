//
//  NotesCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/5/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

protocol  deleteItemDelegate: class {
    
    func deleteItem(_ cell: NotesCell)
    
}


class NotesCell: UITableViewCell {

  
    @IBOutlet weak var notesTextView: UITextView!
    
    weak var delegate: deleteItemDelegate?
    
    @IBAction func deleteItemButtonTappped(_ sender: UIButton) {
        
        delegate?.deleteItem(self)
        
    }
    
}
