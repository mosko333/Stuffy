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
    
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var categoryPicked: CategoryCD? {
        didSet {
            guard let catName = categoryPicked?.name else { return }
            print("category picked \(catName)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTextField.delegate = self
        categoryFRC.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        fetch()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetch()
        setupView()
    }
    
    
    func setupView() {
        // Setup status bar to lightContent because it's changed to dark in the searchVC
        // We set the background colors alpha to 0 because otherwise it's translucent
                UIApplication.shared.statusBarView?.backgroundColor = UIColor(displayP3Red: 30, green: 57, blue: 81, alpha: 0)
        UIApplication.shared.statusBarStyle = .lightContent

        // Set insets to see the bottom cells of the table
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.tableView.contentInset = insets
        
        // Set logo on Nav Bar
        let logo = UIImageView(image: #imageLiteral(resourceName: "xcaBannerNeatly"))
        logo.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = logo
        
        // Changing text color of catergory lable text so the "+" is blue and the "Add a Category" is gray
        let placeHolderText = "+  Add a Category"
        let attributedText = NSMutableAttributedString(string: placeHolderText)
        
        attributedText.addAttributes([NSAttributedStringKey.foregroundColor: Colors.stuffyRoyalBlue, NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 16)!], range: getRangeOfSubString(subString: "+", fromString: placeHolderText)) // Blue color attribute
        
        attributedText.addAttributes([NSAttributedStringKey.foregroundColor: Colors.stuffyDarkGray, NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 16)!], range: getRangeOfSubString(subString: "Add a Category", fromString: placeHolderText)) // Dark Gray color attribute
        
        categoryTextField.attributedText = attributedText
    }
    
    func getRangeOfSubString(subString: String, fromString: String) -> NSRange {
        let sampleLinkRange = fromString.range(of: subString)!
        let startPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.lowerBound)
        let endPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.upperBound)
        let linkRange = NSMakeRange(startPos, endPos - startPos)
        return linkRange
    }
    
    func fetch() {
        do {
            try categoryFRC.performFetch()
        } catch  {
            print("\(error.localizedDescription)")
        }
    }
    
    
    //TABLEVIEW DATA SOURCE FUNCTIONS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryFRC.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        cell.delegate = self
        let category = categoryFRC.object(at: indexPath)
        cell.updateCell(category)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            guard let category = categoryFRC.fetchedObjects?[indexPath.row] else { return }
//            CoreDataStack.context.delete(category)
//        }
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

//        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
//            //TODO: edit the row at indexPath here
//        }
//        editAction.backgroundColor = .blue

        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
//            self.catNames.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.presentDeleteAlertController(indexPathRow: indexPath.row)
//            guard let category = self.categoryFRC.fetchedObjects?[indexPath.row] else { return }
//            CoreDataStack.context.delete(category)
        }
        deleteAction.backgroundColor = Colors.stuffyOrange

        //return [editAction,deleteAction]
        return [deleteAction]
    }
    
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//                print("\(Thread.isMainThread)")
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "MyStuffSegue",sender: self)
//            }
//
////            categoryFRC.object(at: indexPath)
////            self.navigationController?.performSegue(withIdentifier: "MyStuffSegue", sender: self)
//
//
//
////            let categorypicked = categoryFRC.object(at: indexPath)
////            let storyBoard = UIStoryboard(name: "MyStuff", bundle: nil)
////            let destinationVC = storyBoard.instantiateViewController(withIdentifier: "MyStuffNavigationController") as! UINavigationController
////            let topVC = destinationVC.topViewController as! myStuffViewController
////            topVC.categoryPicked = categorypicked
////            //self.navigationController?.pushViewController(myStuffViewController(), animated: true)
////            present(destinationVC, animated: true, completion: nil)
//        }
//
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyStuffSegue" {

            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let categorypicked = categoryFRC.object(at: indexPath)
            if let destinationVC = segue.destination as? MyStuffViewController {
                destinationVC.categoryPicked = categorypicked
            }
        }
    }
}


extension CategoriesViewController: CategoryTableViewCellDelegate {
    func categoryFavorited(_ cell: CategoryTableViewCell) {
        
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







extension CategoriesViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == categoryTextField {
            if textField.text == "" {
                setupView()
            }
        }
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let categoryName = categoryTextField.text, categoryName.count > 0{
        
        CoreDataController.shared.createCategory(name: categoryName)
        
        fetch()
        
        tableView.reloadData()
        
        categoryTextField.text = ""
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Create and Present AlertController
extension CategoriesViewController {
    func presentDeleteAlertController(indexPathRow: Int) {
        let alertController = UIAlertController(title: "Are you sure you want to delete this category?", message: "", preferredStyle: .alert)
        // - Add Actions
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            // AKA What happens when we press the button
            guard let category = self.categoryFRC.fetchedObjects?[indexPathRow] else { return }
            CoreDataStack.context.delete(category)
        }
        let cancelAction  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // - Add actions to alert controller
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        // - Present Alert Controller
        present(alertController, animated: true)
    }
}
