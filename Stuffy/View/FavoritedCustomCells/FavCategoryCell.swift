//
//  FavCategoryCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/8/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class FavCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //updateLabel()
    }
    
    func updateLabel() {
        categoryNameLabel.sizeToFit()
    }
    
}
