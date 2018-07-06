//
//  myStuffViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class myStuffViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate  {
    
    let itemsFRC: NSFetchedResultsController<ItemCD> = {
        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        print("Items were sorted")
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
        
    }()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        itemsFRC.delegate = self
        
        do {
            try itemsFRC.performFetch()
        } catch  {
            print("\(error.localizedDescription)")
        }
        
       collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        collectionView.delegate = self
        collectionView.dataSource = self
        
      
        do {
            try itemsFRC.performFetch()
        } catch  {
            print("\(error.localizedDescription)")
        }
        
       collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myStuffCell", for: indexPath) as? myStuffCell else {return UICollectionViewCell()}
        let item = itemsFRC.object(at: indexPath)
         let data = item.image ?? Data.init()
        let image = UIImage(data: data)
        cell.namelabel.text = item.title
        cell.imageThumbnailView.image = image
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.25
        cell.layer.masksToBounds = false
        cell.clipsToBounds = false 
    
        
        
    return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("there are a total of \(itemsFRC.fetchedObjects?.count)")
        return itemsFRC.fetchedObjects?.count ?? 0
        
    }
   

}
