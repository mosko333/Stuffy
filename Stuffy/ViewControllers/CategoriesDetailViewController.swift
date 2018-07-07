//
//  CategoriesDetailViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/5/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class CategoriesDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categories: [String] = ["unassigned"]
    var categoryPicked: String = ""{
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
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category
    
        
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
        categories.append(newCategory)
        
        tableView.reloadData()
        
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddItemVC2"{
            guard let destinationVC = segue.destination as? NewAddItemTableViewController else { return }
            destinationVC.itemCategory = categoryPicked
        
    }

}
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryPicked = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        performSegue(withIdentifier: "toAddItemVC2", sender: self)
    }
    
}
