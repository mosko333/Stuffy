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
    
    let upcomingReturnsItemFRC:NSFetchedResultsController<ItemCD> = {
        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "lastDayToReturn", ascending: false)
    
        
        request.sortDescriptors = [sortDescriptors]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    let upcomingWarrantyItemFRC:NSFetchedResultsController<ItemCD> = {
        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "warranty", ascending: false)
        
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
    
    @IBOutlet weak var warrantyTable: UITableView!
    
    var currency: String {
        return UserDefaults.standard.object(forKey: CurrencyViewController.Constants.currencyKey) as? String ?? "$" }
    
    var categories: [CategoryCD] {
        do {
            try categoryFRC.performFetch()
        } catch {
            print("❌ Error getting cats in the dashboardVC \(error.localizedDescription)")
        }
        let cat = categoryFRC.fetchedObjects ?? [CategoryCD()]
        return cat
    }
    
    var items: [ItemCD] {
        do {
            try itemFRC.performFetch()
        } catch {
            print("❌ Error getting items in the dashboardVC \(error.localizedDescription)")
        }
        let items = itemFRC.fetchedObjects ?? [ItemCD()]
        return items
    }
    
    var upcomingReturns: [ItemCD]? {
        do {
            try upcomingReturnsItemFRC.performFetch()
        } catch {
            print("❌ Error getting items in the dashboardVC \(error.localizedDescription)")
        }
        let items = itemFRC.fetchedObjects
        return items
    }
    
    var upcomingWarranty: [ItemCD]? {
        do {
            try upcomingWarrantyItemFRC.performFetch()
        } catch {
            print("❌ Error getting items in the dashboardVC \(error.localizedDescription)")
        }
        let items = itemFRC.fetchedObjects
        return items
    }
    
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
            guard let returns = upcomingReturns else { return 0 }
            if returns.count > 1 {
                return 50
            }
        }
        if indexPath.row == 4 {
            guard let returns = upcomingReturns else { return 0 }
            if returns.count > 2 {
                return 50
            }
        }
        if indexPath.row == 5 {
            return 48
        }
        if indexPath.row == 6 {
            return 50
        }
        if indexPath.row == 7 {
            guard let returns = upcomingWarranty else { return 0 }
            if returns.count > 1 {
                return 50
            }
        }
        if indexPath.row == 8 {
            guard let returns = upcomingWarranty else { return 0 }
            if returns.count > 2 {
                return 50
            }
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
            cell.numberOfCats.text = "\(categories.count)"
            cell.numberOfItems.text = "\(items.count)"
            var totalValueOfItems: Double {
                var sum: Double = 0
                for item in items {
                    var price = item.price
                    if item.quantity >= 0 {
                        price *= item.quantity
                    }
                    sum += (price)
                }
                return sum
            }
            cell.totalValueLabel.text = "\(totalValueOfItems)"
            return cell
        }
        if indexPath.row == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "ReturnHeaderCell") as! HeaderTableViewCell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
            if let returns = upcomingReturns, returns.count > 0 {
                cell.nameLabel.text = returns[0].title ?? ""
                if let lastDayToReturn = returns[0].lastDayToReturn {
                    let date = DateFormatter.localizedString(from: lastDayToReturn, dateStyle: .medium, timeStyle: .none)
                    cell.dateLabel.text = "\(date)"
                } else {
                    cell.dateLabel.text = ""
                }
            } else {
                cell.nameLabel.text = "None"
                cell.dateLabel.text = ""
            }
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
            if let returns = upcomingReturns, returns.count > 1 {
                cell.nameLabel.text = returns[1].title ?? ""
                if let lastDayToReturn = returns[1].lastDayToReturn {
                    let date = DateFormatter.localizedString(from: lastDayToReturn, dateStyle: .medium, timeStyle: .none)
                    cell.dateLabel.text = "\(date)"
                } else {
                    cell.dateLabel.text = ""
                }
            }
            return cell
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
            if let returns = upcomingReturns, returns.count > 2 {
                cell.nameLabel.text = returns[2].title ?? ""
                if let lastDayToReturn = returns[2].lastDayToReturn {
                    let date = DateFormatter.localizedString(from: lastDayToReturn, dateStyle: .medium, timeStyle: .none)
                    cell.dateLabel.text = "\(date)"
                } else {
                    cell.dateLabel.text = ""
                }
            }
            return cell
        }
        if indexPath.row == 5 {
            return tableView.dequeueReusableCell(withIdentifier: "WarrantyHeaderCell") as! HeaderTableViewCell
        }
        if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
            if let warranty = upcomingWarranty, warranty.count > 0 {
                cell.nameLabel.text = warranty[0].title ?? ""
                if let lastDayToOfwarranty = warranty[0].lastDayToReturn {
                    let date = DateFormatter.localizedString(from: lastDayToOfwarranty, dateStyle: .medium, timeStyle: .none)
                    cell.dateLabel.text = "\(date)"
                } else {
                    cell.dateLabel.text = ""
                }
            } else {
                cell.nameLabel.text = "None"
                cell.dateLabel.text = ""
            }
            return cell
        }
        if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
            if let warranty = upcomingWarranty, warranty.count > 1 {
                cell.nameLabel.text = warranty[1].title ?? ""
                if let lastDayToOfwarranty = warranty[1].lastDayToReturn {
                    let date = DateFormatter.localizedString(from: lastDayToOfwarranty, dateStyle: .medium, timeStyle: .none)
                    cell.dateLabel.text = "\(date)"
                } else {
                    cell.dateLabel.text = ""
                }
            }
            return cell
        }
        if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
            if let warranty = upcomingWarranty, warranty.count > 2 {
                cell.nameLabel.text = warranty[2].title ?? ""
                if let lastDayToOfwarranty = warranty[2].lastDayToReturn {
                    let date = DateFormatter.localizedString(from: lastDayToOfwarranty, dateStyle: .medium, timeStyle: .none)
                    cell.dateLabel.text = "\(date)"
                } else {
                    cell.dateLabel.text = ""
                }
            }
            return cell
        } else {return UITableViewCell()}
    }
}
