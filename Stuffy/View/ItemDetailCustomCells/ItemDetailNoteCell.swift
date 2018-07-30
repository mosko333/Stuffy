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

    
    func updateCell(with item: ItemCD?) {
        guard let item = item else {return}
        backgroundColor = Colors.stuffyBackgroundGray
        notesTextView.text = item.notes
    }
    
}
