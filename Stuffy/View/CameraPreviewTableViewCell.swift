//
//  CameraPreviewTableViewCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/12/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class CameraPreviewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imagePicked: UIImageView!
    
    func setupCell() {
        imagePicked.frame.origin.x = (superview?.frame.origin.x)!
        imagePicked.frame.origin.y = (superview?.frame.origin.y)!
        
    }
    

}
