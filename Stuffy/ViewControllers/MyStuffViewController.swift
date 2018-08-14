//
//  myStuffViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class MyStuffViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate  {
    
    var categoryItems: [ItemCD] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyItemView: UIView!
    
    
    var categoryPicked: CategoryCD? {
        didSet {
            let catName = categoryPicked?.name ?? "error selecting category"
            print("category has been passed along \(catName)")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.tableView.contentInset = insets
        
        guard let items = categoryPicked?.items?.allObjects as? [ItemCD] else { return }
        categoryItems = items
        print(categoryItems.count)
        setupView()
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
        cell.item = item
        cell.updateCell(with: item)
        
        
    return cell
    }

    func setupView() {
        if categoryItems.count == 0 {
            emptyItemView.isHidden = false
        } else {
            emptyItemView.isHidden = true
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "toItemDetailVC" {
            guard let destinationVC = segue.destination as? UINavigationController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let item = categoryItems[indexPath.row]
            let topVC = destinationVC.topViewController as! ItemDetailViewController
        
           topVC.item = item
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
            
            self.presentDeleteAlertController(indexPathRow: indexPath.row)
        }
        deleteAction.backgroundColor = Colors.stuffyRed
        
        //return [editAction,deleteAction]
        return [deleteAction]
    }
    
    func presentDeleteAlertController(indexPathRow: Int) {
        let alertController = UIAlertController(title: "Are you sure you want to delete this Item?", message: "", preferredStyle: .alert)
        // - Add Actions
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            // AKA What happens when we press the button
            
            let itemToDelete = self.categoryItems[indexPathRow]
            
            
            CoreDataController.shared.deleteItem(with: itemToDelete)
            
           
            
            self.categoryItems.remove(at: indexPathRow)
         
            self.tableView.reloadData()
            
        }
        let cancelAction  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // - Add actions to alert controller
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        // - Present Alert Controller
        present(alertController, animated: true)
    }
}

extension MyStuffViewController: FavoriteItemDelegate {
    func itemFavorited(_ cell: ItemSearchCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = categoryItems[indexPath.row]
        item.isFavorited = !item.isFavorited
        print(item.isFavorited)
        cell.updateCell(with: item)
        CoreDataStack.saveContext()
    }
    
    
}
