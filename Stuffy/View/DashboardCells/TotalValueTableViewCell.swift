//
//  TotalValueTableViewCell.swift
//  Stuffy
//
//  Created by Adam on 19/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class TotalValueTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var numberOfCats: UILabel!
    @IBOutlet weak var numberOfItems: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
