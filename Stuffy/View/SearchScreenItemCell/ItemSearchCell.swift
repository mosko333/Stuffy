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
    @IBOutlet weak var shadowView: UIView!
    
    weak var delegate: FavoriteItemDelegate?
    
    var item: ItemCD?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func updateItem(with item: ItemCD) {
        
        itemNameLabel.text = item.title
        datePurchasedLabel.text = "need to add in"
        if item.isFavorited == true{
             isFavoritedButton.setBackgroundImage(#imageLiteral(resourceName: "xcaItemFavStarFull"), for: .normal)
        } else {
             isFavoritedButton.setBackgroundImage(#imageLiteral(resourceName: "xcaItemFavStarEmpty"), for: .normal)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        datePurchasedLabel.text = dateFormatter.string(from: item.purchaseDate ?? Date()).uppercased()

        guard let images = item.images else {
            print("no images")
            return
        }
        
        guard let coreDataImages = images.allObjects as? [ImageCD] else {
            print(":III(")
            return
        }
        
//        itemImageView.image = UIImage(data: coreDataImages.first!.image!)
        
        
        
        
        
    }
    
    func setupCell() {
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowOpacity = 0.23
        self.shadowView.layer.shadowRadius = 4
    }
    
    @IBAction func isFavoritedButtonTapped(_ sender: UIButton) {
        delegate?.itemFavorited(self)
    }
    
}
