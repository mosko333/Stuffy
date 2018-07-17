//
//  ItemSearchCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/8/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

protocol FavoriteItemDelegate: class {
    func itemFavorited(_ cell: ItemSearchCell)
}

class ItemSearchCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var datePurchasedLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var isFavoritedButton: UIButton!
    
    weak var delegate: FavoriteItemDelegate?
    
    var item: ItemCD?
    
    func updateItem(with item: ItemCD) {
        
        itemNameLabel.text = item.title
        datePurchasedLabel.text = "need to add in"
        if item.isFavorited == true{
             isFavoritedButton.setBackgroundImage(#imageLiteral(resourceName: "xcaFullStar"), for: .normal)
        }
        if item.isFavorited == false {
             isFavoritedButton.setBackgroundImage(#imageLiteral(resourceName: "xcaEmptyStar"), for: .normal)
        }
      //  let data = item.image ?? Data.init()
      //  let image = UIImage(data: data)
       // itemImageView.image   = image
        let dateformatter = DateFormatter()
        datePurchasedLabel.text = dateformatter.string(from: item.purchaseDate ?? Date())
        
    }
  

    
    
    @IBAction func isFavoritedButtonTapped(_ sender: UIButton) {
        delegate?.itemFavorited(self)
    }
    
}
