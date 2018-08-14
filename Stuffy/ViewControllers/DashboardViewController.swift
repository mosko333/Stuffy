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
     let items = CoreDataController.shared.items
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        warrantyTable.reloadData()
        updateViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warrantyTable.delegate = self
        warrantyTable.dataSource = self
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
        
        try? userFRC.performFetch()
        let pin = userFRC.fetchedObjects?.first
        
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell") as? TotalValueTableViewCell else {return UITableViewCell()}
            let currencySymbol = currency.first ?? "$"
            
            cell.currencyLabel.text = "\(currencySymbol)"
            
            cell.updateCell()
            
            return cell
        }
        if indexPath.row == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "ReturnHeaderCell") as! HeaderTableViewCell
        }
        if indexPath.row == 2 {
            if items.count == 0 {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                cell.isHidden = true
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                let upcommingDates = cell.getUpCommingReturnDates()
                let upcommingItemNames = cell.getUpCommingReturnItemNames()
                cell.dateLabel.text = upcommingDates.date1
                cell.nameLabel.text = upcommingItemNames.item1Name
                
                return cell
            }
        }
        if indexPath.row == 3 {
            if items.count > 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                let upcommingDates = cell.getUpCommingReturnDates()
                let upcommingItemNames = cell.getUpCommingReturnItemNames()
                cell.dateLabel.text = upcommingDates.date2
                cell.nameLabel.text = upcommingItemNames.item2Name
                return cell
            } else {
           let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                cell.isHidden = true
                return cell
            }
        }
        if indexPath.row == 4 {
            if items.count > 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                let upcommingDates = cell.getUpCommingReturnDates()
                let upcommingItemNames = cell.getUpCommingReturnItemNames()
                cell.dateLabel.text = upcommingDates.date3
                cell.nameLabel.text = upcommingItemNames.item3Name
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                cell.isHidden = true
                return cell
            }
        }
        if indexPath.row == 5 {
            return tableView.dequeueReusableCell(withIdentifier: "WarrantyHeaderCell") as! HeaderTableViewCell
        }
        if indexPath.row == 6 {
            if items.count == 0 {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                cell.isHidden = true
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                let upcomingWarrantyDates = cell.getUpCommingWarrantyDates()
                let upcomingWarrantyNames = cell.getUpComingWarrantyTitles()
                cell.dateLabel.text = upcomingWarrantyDates.date1
                cell.nameLabel.text = upcomingWarrantyNames.item1Name
                
                return cell
            }
        }
        if indexPath.row == 7 {
            if items.count > 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                
                let upcomingWarrantyDates = cell.getUpCommingWarrantyDates()
                let upcomingWarrantyNames = cell.getUpComingWarrantyTitles()
                cell.dateLabel.text = upcomingWarrantyDates.date2
                cell.nameLabel.text = upcomingWarrantyNames.item2Name
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                cell.isHidden = true
                return cell
            }
        }
        if indexPath.row == 8 {
            if items.count > 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                let upcomingWarrantyDates = cell.getUpCommingWarrantyDates()
                let upcomingWarrantyNames = cell.getUpComingWarrantyTitles()
                cell.dateLabel.text = upcomingWarrantyDates.date3
                cell.nameLabel.text = upcomingWarrantyNames.item3Name
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell") as! ReturnAndWarrantyTableViewCell
                cell.isHidden = true
                return cell
            }
        }else { return UITableViewCell()}
    }

}

