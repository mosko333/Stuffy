//
//  SettingsViewController.swift
//  Stuffy
//
//  Created by Adam on 07/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    var currency: String {
        return UserDefaults.standard.object(forKey: CurrencyViewController.Constants.currencyKey) as? String ?? "$ Dollar" }
    var pinIsOn: Bool {
        return UserDefaults.standard.object(forKey: PinPadViewController.Constants.isPinActiveKey) as? Bool ?? false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.delegate = self
        settingsTable.dataSource = self
        self.settingsTable.rowHeight = 77
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        settingsTable.reloadData()
    }
    
    @IBAction func backBarButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResetPinSegue" {
            if let destinationVC = segue.destination as? PinPadViewController {
                destinationVC.actionWanted = .resetPin
            }
        }
        
        if segue.identifier == "TurnOnOffPinSegue" {
            if let destinationVC = segue.destination as? PinPadViewController {
                print("settingsVC Pin \(pinIsOn)")
                if !pinIsOn {
                    destinationVC.actionWanted = .turnOn
                } else {
                    destinationVC.actionWanted = .turnOff
                }
            }
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouchIDCell") as! TouchIDTableViewCell
            cell.pinSwitch.isOn = pinIsOn
            return cell
        }
        if indexPath.row == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "ResetCell") as! ResetAndEraseTableViewCell
        }
        if indexPath.row == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "EraseCell") as! ResetAndEraseTableViewCell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell") as! CurrencyPickerTableViewCell
            cell.currencyLabel.text = currency
            return cell
        } else {return UITableViewCell()}
    }
}
