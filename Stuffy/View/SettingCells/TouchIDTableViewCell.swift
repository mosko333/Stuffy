//
//  TouchIDTableViewCell.swift
//  Stuffy
//
//  Created by Adam on 07/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class TouchIDTableViewCell: UITableViewCell {
    
    struct Constants {
        static let isPinActiveKey = "isPinActive"
    }
    
    @IBOutlet weak var pinSwitch: UISwitch!
    
    let defaults = UserDefaults.standard
    var pinIsOn: Bool {
        return UserDefaults.standard.object(forKey: Constants.isPinActiveKey) as? Bool ?? false }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // set switch state to UserDefaults state
        pinSwitch.isOn = pinIsOn
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func pinSwitchToggled(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: Constants.isPinActiveKey)
    }
}
