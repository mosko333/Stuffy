//
//  SearchItemsViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/8/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class SearchItemsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
   
    
    
    let itemFRC:NSFetchedResultsController<ItemCD> = {
        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var beginSearch = false
    
    var searchedItems: [ItemCD] = []{
        didSet{
            print("item added to search items array")
        }
    }
    var emptyArray: [ItemCD] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        do {
            try itemFRC.performFetch()
            guard let items = itemFRC.fetchedObjects else {return }
            emptyArray = items
        } catch  {
            print("\(error.localizedDescription)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemFRC.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        print(searchedItems.count)
        
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if beginSearch == false {
            return emptyArray.count
        }
        if beginSearch == true {
            return searchedItems.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Items"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if beginSearch == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemSearchCell
            cell.delegate = self
            let item = emptyArray[indexPath.row]
            cell.updateItem(with: item)
            return cell
            
        }
        if beginSearch == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemSearchCell
            cell.delegate = self
            let item = searchedItems[indexPath.row]
            cell.updateItem(with: item)
            return cell
            
        }
        return UITableViewCell()
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        beginSearch = true
        guard let searchText = searchBar.text else { return }
        let characterSet = CharacterSet(charactersIn: searchText)
        for item in emptyArray {
            if item.title?.rangeOfCharacter(from: characterSet) != nil {
                searchedItems.append(item)
            }
        }
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
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

extension SearchItemsViewController: FavoriteItemDelegate {
    func itemFavorited(_ cell: ItemSearchCell) {
        let indexPath = tableView.indexPath(for: cell)
        
        let item = itemFRC.object(at: indexPath!)
        
        item.isFavorited = !item.isFavorited
        print(item.isFavorited)
        cell.updateItem(with: item)
        CoreDataStack.saveContext()
    }
    
    
}
