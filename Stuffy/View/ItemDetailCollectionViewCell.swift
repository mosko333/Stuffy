//
//  ItemDetailCollectionViewCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class ItemDetailCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var coverPhotoButton: UIButton!
    
    
    func updateCell(with photo: UIImage){
        
        photoImageView.image = photo
    }
    
}
