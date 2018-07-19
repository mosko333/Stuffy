//
//  FavoriteItemsViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/8/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class FavoriteItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate  {
    
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
        

    @IBOutlet weak var tableView: UITableView!
    
    var favoritedCategories: [CategoryCD] = []
    var favoritedItems: [ItemCD] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoritedItems = []
        favoritedCategories = []
        do {
            try categoryFRC.performFetch()
            guard categoryFRC.fetchedObjects != nil else { return }
            guard  let categories = categoryFRC.fetchedObjects else {return }
            for category in categories {
                if category.isFavorited == true {
                    favoritedCategories.append(category)
//                    let set = Set(favoritedCategories)
                }
            }
            
            let favCategoriesSet = Set(favoritedCategories)
            favoritedCategories = Array(favCategoriesSet)
        } catch  {
            print("\(error.localizedDescription)")
        }
        do {
            try itemFRC.performFetch()
            guard let items = itemFRC.fetchedObjects else {return }
            for item in items{
                if item.isFavorited == true {
                    favoritedItems.append(item)
                }
            }
            let faveItemsSet = Set(favoritedItems)
            favoritedItems = Array(faveItemsSet)
        } catch  {
            print("\(error.localizedDescription)")
        }
        
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(displayP3Red: 30, green: 57, blue: 81, alpha: 0)
        UIApplication.shared.statusBarStyle = .lightContent
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.tableView.contentInset = insets
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryFRC.delegate = self
        itemFRC.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Colors.stuffyBackgroundGray

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            print(favoritedCategories.count)
            return favoritedCategories.count
        }
        if section == 1 {
            return favoritedItems.count
        }
        
        return 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCategoryCell", for: indexPath) as! FavCategoryCell
            let category = favoritedCategories[indexPath.row]
            cell.categoryNameLabel.text = category.name
            let itemCount = category.items?.count ?? 0
            cell.categoryCountLabel.text = "(\(itemCount))"
            cell.backgroundColor = Colors.stuffyBackgroundGray
            //cell.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemSearchCell
          
            let item = favoritedItems[indexPath.row]
            cell.updateItem(with: item)
            return cell
        }
      return UITableViewCell()
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 61.0
        } else {
            return 95
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let categoryHeaderView = UIView()
        let label = UILabel()
        label.layer.backgroundColor = Colors.stuffyBackgroundGray.cgColor
        
        label.font = UIFont.init(name: "Avenir-Heavy", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 64).isActive = true
        categoryHeaderView.addSubview(label)
        categoryHeaderView.backgroundColor = Colors.stuffyBackgroundGray
        if section == 0 {
            label.text = "    Categories"
            let lineSeparatorView = UIView()
            categoryHeaderView.addSubview(lineSeparatorView)
            lineSeparatorView.layer.backgroundColor = Colors.stuffyLightGray.cgColor
            lineSeparatorView.translatesAutoresizingMaskIntoConstraints = false
            lineSeparatorView.bottomAnchor.constraint(equalTo: categoryHeaderView.bottomAnchor, constant: 0).isActive = true
            lineSeparatorView.leftAnchor.constraint(equalTo: categoryHeaderView.leftAnchor, constant: 0).isActive = true
            lineSeparatorView.rightAnchor.constraint(equalTo: categoryHeaderView.rightAnchor, constant: 0).isActive = true
            lineSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return categoryHeaderView
        }
        if section == 1 {
            label.text = "    Items"
        }
        return categoryHeaderView
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
