//
//  myStuffViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class MyStuffViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate  {
    
    let itemsFRC:NSFetchedResultsController<ItemCD> = {
        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [ItemCD] = []
    var categoryItems: [ItemCD] = []
    var categoryPicked: CategoryCD? {
        didSet {
            let catName = categoryPicked?.name ?? "error selecting category"
            print("category has been passed along \(catName)")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        itemsFRC.delegate = self
        
        do {
            try itemsFRC.performFetch()
            guard let itemsFetched = itemsFRC.fetchedObjects else { return }
            for item in itemsFetched {
                if item.category == categoryPicked {
                    categoryItems.append(item)
                }
            }
            print("number of items fetched \(categoryItems.count)")
        } catch  {
            print("\(error.localizedDescription)")
        }
        
       tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = categoryPicked?.name
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myStuffCell", for: indexPath) as? ItemSearchCell else {return UITableViewCell()}
        cell.delegate = self
        let item =  categoryItems[indexPath.row]
        cell.updateItem(with: item)
        
    return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewItemButtonPressed(_ sender: UIBarButtonItem) {
        print("add item button pressed")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toAddItemNavController" {
//            let destinationVC = segue.destination as! UINavigationController
//            let topVC = destinationVC.topViewController as! NewAddItemTableViewController
//            topVC.categoryPicked = categoryPicked
//        }
//    }

}

extension MyStuffViewController: FavoriteItemDelegate {
    func itemFavorited(_ cell: ItemSearchCell) {
        let indexPath = tableView.indexPath(for: cell)
        
        let item = itemsFRC.object(at: indexPath!)
        
        item.isFavorited = !item.isFavorited
        print(item.isFavorited)
        cell.updateItem(with: item)
        CoreDataStack.saveContext()
    }
    
    
}
