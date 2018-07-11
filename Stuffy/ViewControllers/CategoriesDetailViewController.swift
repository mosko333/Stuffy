//
//  CategoriesDetailViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/5/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class CategoriesDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    let itemsFRC: NSFetchedResultsController<CategoryCD> = {
        let request: NSFetchRequest<CategoryCD> = CategoryCD.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        print("Categories were sorted")
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
        
    }()
    
    var categoryPicked: CategoryCD? {
        didSet {
            print("category has been picked")
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryNameTextField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        categoryView.frame.origin.y += 700
        categoryNameTextField.addDoneButtonOnKeyboard()
        
        itemsFRC.delegate = self
        do {
            try itemsFRC.performFetch()
        } catch  {
            print("\(error.localizedDescription)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsFRC.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
        let category = itemsFRC.object(at: indexPath)
        cell.textLabel?.text = category.name
    
        
        return cell
    }
    
    
    
    
    @IBAction func addCategoryButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.categoryView.frame.origin.y -= 700
        }
        
    }
    
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.categoryView.frame.origin.y += 700
    }
}
    @IBAction func categorySaveButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.categoryView.frame.origin.y += 700
        
    }
 guard let newCategory = categoryNameTextField.text, newCategory.count > 0 else { return }
        ItemCoreDataController.shared.createCategory(name: newCategory)
        
       
        
        do {
            try itemsFRC.performFetch()
        } catch  {
            print("\(error.localizedDescription)")
        }
        tableView.reloadData()
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddItemVC2"{
            let destinationVC = segue.destination as! UINavigationController
            let topVC = destinationVC.topViewController as! NewAddItemTableViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let categorypicked = itemsFRC.object(at: indexPath)
            
            topVC.categoryPicked = categorypicked
        
    }
}
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
}
