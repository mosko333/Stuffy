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
    
    let currency = ["$", "£", "₪", "€", "₫", "₱", "р.", "₨", "₣", "¥", "₩", "₴", "kr", "د.إ", "ر.س"]
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.delegate = self
        settingsTable.dataSource = self
        self.settingsTable.rowHeight = 77
        setupView()
    }

    func setupView() {
    }
    @IBAction func backBarButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "TouchIDCell") as! TouchIDTableViewCell
        }
        if indexPath.row == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "ResetCell") as! ResetAndEraseTableViewCell
        }
        if indexPath.row == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "EraseCell") as! ResetAndEraseTableViewCell
        } else {return UITableViewCell()}
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TouchIDCell") as? TouchIDTableViewCell else { return UITableViewCell() }
//        return cell
        
    }
    
    
}
