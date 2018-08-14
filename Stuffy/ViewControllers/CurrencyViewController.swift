//
//  CurrencyViewController.swift
//  Stuffy
//
//  Created by Adam on 16/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    struct Constants {
        static let currencyKey = "currency"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    let currency = ["$ Dollar",
                    "£ Pound",
                    "₪ Shekel",
                    "€ Euro",
                    "₫ Đồng",
                    "₹ Rupee",
                    "₣ Franc",
                    "¥ Yen",
                    "₩ Won",
                    "₴ Hryvnia"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Set insets to see the bottom cells of the table
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.tableView.contentInset = insets
    }
    @IBAction func backBarButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        cell.textLabel?.font = UIFont.init(name: "Avenir-Book", size: 16)
        cell.textLabel?.text = currency[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = self.currency[indexPath.row]
        defaults.set(currency, forKey: Constants.currencyKey)
        navigationController?.popViewController(animated: true)
    }
}
