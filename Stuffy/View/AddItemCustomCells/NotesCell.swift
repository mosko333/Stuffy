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

  
    @IBOutlet weak var addNotesLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    var item: ItemCD?
    
    weak var delegate: deleteItemDelegate?
    
    @IBAction func deleteItemButtonTappped(_ sender: UIButton) {
        
        delegate?.deleteItem(self)
    }
    
    func addDoneButton() {
        notesTextView.addDoneButtonOnKeyboard()
    
    }
    func setupNotesCell() {
        
        if item != nil {
        deleteButton.isHidden = false
        deleteButton.isUserInteractionEnabled = true
        } else {
        deleteButton.isHidden = true
        deleteButton.isUserInteractionEnabled = false
        }
        // setting up place holder text. 
        let placeHolderText = "Add Notes"
        let attributedText = NSMutableAttributedString(string: placeHolderText)
        
        attributedText.addAttributes([NSAttributedStringKey.foregroundColor:Colors.stuffyLightGray, NSAttributedStringKey.font: UIFont(name: "Avenir-Roman", size: 16)!], range: getRangeOfSubString(subString: "Add Notes", fromString: placeHolderText))
        
        notesTextView.attributedText = attributedText
    }
    // fuction for the placeholder text.
    func getRangeOfSubString(subString: String, fromString: String) -> NSRange {
        let sampleLinkRange = fromString.range(of: subString)!
        let startPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.lowerBound)
        let endPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.upperBound)
        let linkRange = NSMakeRange(startPos, endPos - startPos)
        return linkRange
    }
}
