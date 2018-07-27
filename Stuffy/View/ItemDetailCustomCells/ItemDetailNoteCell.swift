//
//  ItemDetailNoteCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/27/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit


class ItemDetailNoteCell: UITableViewCell {

    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var deleteItemButton: UIButton!
    
    @IBAction func deleteItemButton(_ sender: UIButton) {
    }
    
    func updateCell(with item: ItemCD?) {
        guard let item = item else {return}
        
        notesTextView.text = item.notes
    }
    
}
