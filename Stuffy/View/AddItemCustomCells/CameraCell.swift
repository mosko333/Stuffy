//
//  CameraCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/26/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class CameraCell: UITableViewCell {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButon: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
    }
    
}
