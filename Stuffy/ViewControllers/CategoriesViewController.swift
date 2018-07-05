//
//  CategoriesViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/2/17.
//  Copyright © 2017 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    
    let itemsFRC: NSFetchedResultsController<ItemCoreData> = {
        let request: NSFetchRequest<ItemCoreData> = ItemCoreData.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "Categories", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        print("Items were sorted")
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
        
    }()
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCategoryView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var categoryNameTextField: UITextField!
    
    var categories: [String] = ["Unassigned"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            addCategoryView.frame.origin.y += 700
        
        buttonStackView.frame.size.width = addCategoryView.frame.size.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        categoryNameTextField.addDoneButtonOnKeyboard()

        
    }

    
    //TABLEVIEW DATA SOURCE FUNCTIONS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
        
        let categoryForCell = categories[indexPath.row]
        cell.textLabel?.text = categoryForCell
        cell.imageView?.image = UIImage(named: "xcaCategoriesBox")
        cell.detailTextLabel?.text = "More"
        
        return cell
        
    }
    
    
    @IBAction func presentCategoryView(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.addCategoryView.center.y -= 700
        }
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let categoryName = categoryNameTextField.text, categoryName.count > 0 else {return}
        
        categories.append(categoryName)
        
        tableView.reloadData()
        
        UIView.animate(withDuration: 0.5) {
            self.addCategoryView.center.y += 700
        }
        
    
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.addCategoryView.center.y += 700
            
        }
    }
    
}
