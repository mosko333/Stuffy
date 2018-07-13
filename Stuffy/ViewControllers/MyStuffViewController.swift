//
//  myStuffViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class MyStuffViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate  {
    
    let itemsFRC:NSFetchedResultsController<ItemCD> = {
        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    var items: [ItemCD] = []
    var categoryItems: [ItemCD] = []
    var categoryPicked: CategoryCD? {
        didSet {
            let catName = categoryPicked?.name ?? "error selecting category"
            print("category has been passed along \(catName)")
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
       collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.title = categoryPicked?.name
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myStuffCell", for: indexPath) as? myStuffCell else {return UICollectionViewCell()}
        
        let item =  categoryItems[indexPath.row]
         let data = item.image ?? Data.init()
        let image = UIImage(data: data)
        let finalImage = UIImage(cgImage: (image?.cgImage)!, scale: 1.0, orientation: .right)
        cell.namelabel.text = item.title
        cell.imageThumbnailView.image = finalImage
        
    return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItems.count
        
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
