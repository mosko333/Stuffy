//
//  CategoriesViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/2/17.
//  Copyright © 2017 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    let categoryFRC: NSFetchedResultsController<CategoryCD> = {
        let request: NSFetchRequest<CategoryCD> = CategoryCD.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        print("Categories were sorted")
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
        
    }()
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCategoryView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var showCategoryViewButton: UIButton!
    
    var categoryPicked: CategoryCD? {
        didSet {
            print("category picked \(categoryPicked?.name)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            addCategoryView.frame.origin.y += 700
        
        buttonStackView.frame.size.width = addCategoryView.frame.size.width
        
        categoryFRC.delegate = self
        do {
            try categoryFRC.performFetch()
        } catch  {
            print("\(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryFRC.delegate = self
        do {
            try categoryFRC.performFetch()
        } catch  {
            print("\(error.localizedDescription)")
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        categoryNameTextField.addDoneButtonOnKeyboard()

        
    }

    
    //TABLEVIEW DATA SOURCE FUNCTIONS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return categoryFRC.fetchedObjects?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath) as! HomeScreenCategoryCell
        cell.delegate = self
        let category = categoryFRC.object(at: indexPath)
        cell.updateCell(category)
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorypicked = categoryFRC.object(at: indexPath)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyBoard.instantiateViewController(withIdentifier: "MyStuffNavigationController") as! UINavigationController
       let topVC = destinationVC.topViewController as! myStuffViewController
        topVC.categoryPicked = categorypicked
        present(destinationVC, animated: true, completion: nil)
        
     
    }
    
    @IBAction func presentCategoryView(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.addCategoryView.center.y -= 700
        }
        
        showCategoryViewButton.isUserInteractionEnabled = false
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let categoryName = categoryNameTextField.text, categoryName.count > 0 else {return}
        
        ItemCoreDataController.shared.createCategory(name: categoryName)
        
        
        UIView.animate(withDuration: 0.5) {
            self.addCategoryView.center.y += 700
        }
        
        do {
            try categoryFRC.performFetch()
        } catch  {
            print("\(error.localizedDescription)")
        }
        tableView.reloadData()
        showCategoryViewButton.isUserInteractionEnabled = true
        categoryNameTextField.text = ""
    }
    
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.addCategoryView.center.y += 700
        }
        showCategoryViewButton.isUserInteractionEnabled = true
        categoryNameTextField.text = ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = categoryFRC.object(at: indexPath)
            ItemCoreDataController.shared.deleteCategory(with: category)
            
            print("category was deleted")
        }
    }
    
}

extension CategoriesViewController: FavoriteCategoryDelegate {
    func categoryFavorited(_ cell: HomeScreenCategoryCell) {
        
        let indexPath = tableView.indexPath(for: cell)
        
        let category = categoryFRC.object(at: indexPath!)
        
        category.isFavorited = !category.isFavorited
        print(category.isFavorited)
        cell.updateCell(category)
        
        CoreDataStack.saveContext()
    }
}

extension CategoriesViewController {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
            
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type{
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
            
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
            
        default:
            return
        }
    }}
