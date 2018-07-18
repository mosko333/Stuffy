//
//  CategoryTableViewCell.swift
//  Stuffy
//
//  Created by Adam on 11/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

protocol  CategoryTableViewCellDelegate: class {
    func categoryFavorited(_ cell: CategoryTableViewCell)
}

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryCountLabel: UILabel!
    @IBOutlet weak var isFavoritedButton: UIButton!
    
    weak var delegate: CategoryTableViewCellDelegate?
    
    var category: CategoryCD?
    
    
    func updateCell(_ category: CategoryCD) {
        categoryNameLabel.text = category.name
        let itemCount = category.items?.count ?? 0
        categoryCountLabel.text = "(\(itemCount))"
        
        if category.isFavorited == true {
            isFavoritedButton.setBackgroundImage(#imageLiteral(resourceName: "xcaCatFavStarFull"), for: .normal)
        }
        if category.isFavorited == false {
            isFavoritedButton.setBackgroundImage(#imageLiteral(resourceName: "xcaCatFavStarEmpty"), for: .normal)
        }
    }
    
    @IBAction func isFavoritedButtonTapped(_ sender: UIButton) {
        delegate?.categoryFavorited(self)
    }
}
