//
//  CurrencyViewController.swift
//  Stuffy
//
//  Created by Adam on 16/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

protocol CurrencyViewControllerDelegate: class {
    func selectCurrency(currency: String)
}

class CurrencyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: CurrencyViewControllerDelegate?
    
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
    }
}

extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currency.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Currency Cell", for: indexPath)
        cell.textLabel?.font = UIFont.init(name: "Avenir-Book", size: 16)
        cell.textLabel?.text = currency[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currency = currency[indexPath.row].first else { return }
        self.delegate?.selectCurrency(currency: String(currency))
        navigationController?.popViewController(animated: true)
    }
}
