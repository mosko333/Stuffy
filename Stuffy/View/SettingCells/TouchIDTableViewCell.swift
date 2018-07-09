//
//  TouchIDTableViewCell.swift
//  Stuffy
//
//  Created by Adam on 07/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
protocol TouchIDTableViewCellDelegate: class {
    func pinOnOffToggle(pinIsOn: Bool)
}

class TouchIDTableViewCell: UITableViewCell {

    weak var delegate: TouchIDTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pinSwitchToggled(_ sender: UISwitch) {
        delegate?.pinOnOffToggle(pinIsOn: sender.isOn)
    }
}
