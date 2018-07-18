//
//  FavItemCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/8/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class FavItemCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var isFavoritedButton: UIButton!
    @IBOutlet weak var datePurchasedLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    weak var delegate: FavoriteItemDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    
    func updateItem(with item: ItemCD) {
        
        itemNameLabel.text = item.title
        datePurchasedLabel.text = "need to add in"
        if item.isFavorited == true{
            isFavoritedButton.setBackgroundImage(#imageLiteral(resourceName: "xcaFullStar"), for: .normal)
        } else {
            isFavoritedButton.setBackgroundImage(#imageLiteral(resourceName: "xcaEmptyStar"), for: .normal)
        }
        //let data = item.image ?? Data.init()
       // let image = UIImage(data: data)
        // itemImageView.image = image
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        datePurchasedLabel.text = dateFormatter.string(from: item.purchaseDate ?? Date()).uppercased()
        
    }
    
    func setupCell() {
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowOpacity = 0.23
        self.shadowView.layer.shadowRadius = 4
    }
    

    @IBAction func isFavoritedButtonTapped(_ sender: Any) {
        //delegate?.itemFavorited(self)
    }
}
