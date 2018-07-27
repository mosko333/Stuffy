//
//  ItemDetailViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailViewController: UIViewController, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    let imageFRC: NSFetchedResultsController<ImageCD> = {
        let request: NSFetchRequest<ImageCD> = ImageCD.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "image", ascending: true)
        request.sortDescriptors = [sortDescriptors]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
        
    }()
    var itemPhotos: [ImageCD] = []
    var allPhotos: [ImageCD] = []
    var item: ItemCD?{
        didSet{
            print("item was passed along")
        }
    }
   
    @IBOutlet weak var itemDetailCollectionView: UICollectionView!
    @IBOutlet weak var itemDetailTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       try? imageFRC.performFetch()
        allPhotos = imageFRC.fetchedObjects!
        for photo in allPhotos {
            if photo.item?.title == item?.title {
                   itemPhotos.append(photo)
                    print("the total amount of pictures for this item is :\(itemPhotos.count)")
        
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemDetailCollectionView.dataSource = self
        imageFRC.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemPhotos.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = itemDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailImageCell", for: indexPath) as? ItemDetailCollectionViewCell else {return UICollectionViewCell()}
        let photo = itemPhotos[indexPath.row]
    
        cell.updateCell(with: photo)
        
        return cell
    }

}
