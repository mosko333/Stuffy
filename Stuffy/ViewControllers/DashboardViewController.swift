//
//  DashboardViewController.swift
//  Stuffy
//
//  Created by Adam on 07/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    let categoryFRC: NSFetchedResultsController<CategoryCD> = {
        let request: NSFetchRequest<CategoryCD> = CategoryCD.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        print("Categories were sorted")
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
        
    }()
    
    let itemFRC:NSFetchedResultsController<ItemCD> = {
        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    let userFRC:NSFetchedResultsController<User> = {
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "pin", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    //////////////////////
    // MARK: Properties
    //////////////////////
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var numberOfCatLabel: UILabel!
    @IBOutlet var returnItemNameLabel: [UILabel]!
    @IBOutlet var returnItemDateLabel: [UILabel]!
    
    @IBOutlet weak var warrantyTable: UITableView!
    
    var currency: String {
        return UserDefaults.standard.object(forKey: CurrencyViewController.Constants.currencyKey) as? String ?? "$" }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warrantyTable.delegate = self
        warrantyTable.dataSource = self
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        warrantyTable.reloadData()
        updateViews()
    }
    
    func updateViews() {
        // Setup status bar to lightContent because it's changed to dark in the searchVC
        // We set the background colors alpha to 0 because otherwise it's translucent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(white: 0, alpha: 0)
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Set insets to see the bottom cells of the table
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.warrantyTable.contentInset = insets
        
        // TODO - Populate Views using search data
        try? categoryFRC.performFetch()
        //numberOfCatLabel.text = "\(categoryFRC.fetchedObjects!.count)"
        
        try? itemFRC.performFetch()
        //let moneyMoneyMoney = itemFRC.fetchedObjects ?? []
        //for money in moneyMoneyMoney {
        //let value = money.price
        //}
        
        try? userFRC.performFetch()
        //let pin = userFRC.fetchedObjects?.first
        
        //currencyLabel.text = currency
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        if section == 0 {
    //            //return "Upcoming Return Dates"
    //            let backgroundView = UIView()
    //            backgroundView.backgroundColor = .white
    //            let underline = UIView()
    //            let title = UILabel()
    //            title.font = UIFont(name: "Avenir-Medium", size: 10)
    //            title.text = "Upcoming Return Dates"
    //            title.textColor = Colors.stuffyMedGray
    //            underline.backgroundColor = Colors.stuffyLightGray
    //            backgroundView.addSubview(title)
    //            backgroundView.addSubview(underline)
    //            title.translatesAutoresizingMaskIntoConstraints = false
    //            let labelTop = NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0)
    //            let labelLeft = NSLayoutConstraint(item: title, attribute: .leftMargin, relatedBy: .equal, toItem: backgroundView, attribute: .leftMargin, multiplier: 1, constant: 22)
    //            underline.translatesAutoresizingMaskIntoConstraints = false
    //            let underlineBottem = NSLayoutConstraint(item: underline, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: 0)
    //            let underlineLeft = NSLayoutConstraint(item: underline, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 22)
    //            let underlineRight = NSLayoutConstraint(item: underline, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -22)
    //            let underlineHeight = NSLayoutConstraint(item: underline, attribute: .height, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 0, constant: 1)
    //            backgroundView.addConstraints([labelTop, labelLeft, underlineBottem, underlineLeft, underlineRight, underlineHeight])
    //            return backgroundView
    //        }
    //        if section == 1 {
    //            //return "Upcoming Return Dates"
    //            let backgroundView = UIView()
    //            let title = UILabel()
    //            title.font = UIFont(name: "Avenir-Medium", size: 10)
    //            title.text = "Upcoming Warranty Expirations"
    //            title.textColor = Colors.stuffyMedGray
    //            backgroundView.addSubview(title)
    //            title.translatesAutoresizingMaskIntoConstraints = false
    //            let labelTop = NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0)
    //            let labelCenterX = NSLayoutConstraint(item: title, attribute: .leftMargin, relatedBy: .equal, toItem: backgroundView, attribute: .leftMargin, multiplier: 1, constant: 22)
    //
    //            backgroundView.addConstraints([labelTop, labelCenterX])
    //            return backgroundView
    //        }
    //        return UIView()
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 80
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let backgroundView = UIView()
    //        backgroundView.translatesAutoresizingMaskIntoConstraints = false
    //        backgroundView.backgroundColor = UIColor.white
    //        let underline = UIView()
    //        backgroundView.addSubview(underline)
    //        underline.backgroundColor = Colors.stuffyOrange
    //        underline.translatesAutoresizingMaskIntoConstraints = false
    //        let underlineTop = NSLayoutConstraint(item: underline, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0)
    //        let underlineLeft = NSLayoutConstraint(item: underline, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 22)
    //        let underlineRight = NSLayoutConstraint(item: underline, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -22)
    //        let underlineHeight = NSLayoutConstraint(item: underline, attribute: .height, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 0, constant: 100)
    //        backgroundView.addConstraints([underlineTop, underlineLeft, underlineRight, underlineHeight])
    //        return backgroundView
    //    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.row == 0 {
            return 280
        }
        if indexPath.row == 1 {
            return 48
        }
        if indexPath.row == 2 {
            return 50
        }
        if indexPath.row == 3 {
            return 50
        }
        if indexPath.row == 4 {
            return 50
        }
        if indexPath.row == 5 {
            return 48
        }
        if indexPath.row == 6 {
            return 50
        }
        if indexPath.row == 7 {
            return 50
        }
        if indexPath.row == 8 {
            return 50
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell") as! TotalValueTableViewCell
            let currencySymbol = currency.first ?? "$"
            cell.currencyLabel.text = "\(currencySymbol)"
            try? categoryFRC.performFetch()
            cell.numberOfCats.text = "\(categoryFRC.fetchedObjects!.count)"
            return cell
        }
        if indexPath.row == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "ReturnHeaderCell") as! HeaderTableViewCell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCellOne") as! ReturnAndWarrantyTableViewCell
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCellTwo") as! ReturnAndWarrantyTableViewCell
            return cell
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCellThree") as! ReturnAndWarrantyTableViewCell
            return cell
        }
        if indexPath.row == 5 {
            return tableView.dequeueReusableCell(withIdentifier: "WarrantyHeaderCell") as! HeaderTableViewCell
        }
        if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WarrantyCellOne") as! ReturnAndWarrantyTableViewCell
            return cell
        }
        if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WarrantyCellTwo") as! ReturnAndWarrantyTableViewCell
            return cell
        }
        if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WarrantyCellThree") as! ReturnAndWarrantyTableViewCell
            return cell
    } else {return UITableViewCell()}
}
}
