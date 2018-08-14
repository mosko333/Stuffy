//
//  SearchItemsViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/8/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class SearchItemsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var searchBar: UISearchBar?
    
    let itemFRC:NSFetchedResultsController<ItemCD> = {
        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchArray: [ItemCD] = []
    var allItems: [ItemCD] = [] {
        didSet {
            searchArray = allItems
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
            self.tableView.contentInset = insets
            tableView.reloadData()
        }
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        do {
            try itemFRC.performFetch()
            guard let items = itemFRC.fetchedObjects else {return }
            allItems = items
            print(items.count)
            tableView.reloadData()
        } catch  {
            print("\(error.localizedDescription)")
        }
        
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarView?.backgroundColor = .white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemFRC.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Colors.stuffyBackgroundGray
        setSearchBar()
        setupShadowView()
        
    }
    
    fileprivate func setSearchBar() {
        let searchBar = UISearchBar()
        
        let textFieldInUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInUISearchBar?.font = UIFont(name: "Avenir-Roman", size: 16)
        textFieldInUISearchBar?.layer.borderWidth = 1.5
        textFieldInUISearchBar?.layer.borderColor = Colors.stuffyDarkGray.cgColor
        textFieldInUISearchBar?.layer.cornerRadius = 18
        textFieldInUISearchBar?.clipsToBounds = true
        searchBar.barStyle = UIBarStyle.default
        searchBar.layer.backgroundColor = UIColor.white.cgColor
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        let cancelButtonAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 18)]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: .normal)
       
        self.searchBar = searchBar
        self.searchBar?.delegate = self
        navigationItem.titleView = searchBar
        if (searchBar.text?.count)! < 1  {
            searchBar.resignFirstResponder()
        }
    }
    
    func setupShadowView() {
        guard let navBar = navigationController?.navigationBar else { return }
        let shadowView = UIView(frame: navBar.frame)
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor(white: 0.75, alpha: 1).cgColor
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 15)
        shadowView.layer.shadowRadius = 2
        view.addSubview(shadowView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()
        label.layer.backgroundColor = Colors.stuffyBackgroundGray.cgColor
        label.text = "     Items"
        label.font = UIFont.init(name: "Avenir-Heavy", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 63).isActive = true
        headerView.addSubview(label)
        headerView.backgroundColor = Colors.stuffyBackgroundGray
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemSearchCell else { return UITableViewCell()}
        cell.delegate = self
        let item = searchArray[indexPath.row]
        cell.updateCell(with: item)
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
}

extension SearchItemsViewController: FavoriteItemDelegate {
    func itemFavorited(_ cell: ItemSearchCell) {
        let indexPath = tableView.indexPath(for: cell)
        
        let item = itemFRC.object(at: indexPath!)
        
        item.isFavorited = !item.isFavorited
        print(item.isFavorited)
        cell.updateCell(with: item)
        CoreDataStack.saveContext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItemDetailVC2" {
            guard let destinationVC = segue.destination as? UINavigationController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let item = searchArray[indexPath.row]
            let topVC = destinationVC.topViewController as! ItemDetailViewController
            
            topVC.item = item
        }
    }
}

extension SearchItemsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            searchArray = allItems
        } else {
            searchArray = allItems.filter {
                guard let title = $0.title?.lowercased() else { return false }
                return title.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchArray = allItems
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}


