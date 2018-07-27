//
//  ItemDetailViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailViewController: UIViewController, UICollectionViewDataSource {
    
 
    var itemPhotosArray: [ImageCD] = []
    var item: ItemCD? {
        didSet{
            print("item was passed along")
        }
    }
    var category: CategoryCD? {
        didSet {
            print("category has been set")
        }
    }
    @IBOutlet weak var itemDetailCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard var itemPhotos = item?.images?.allObjects as? [ImageCD] else {return}
        
        itemPhotos = itemPhotosArray
         category = item?.category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemDetailCollectionView.dataSource = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    // CollectionView fuctions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemPhotosArray.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = itemDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailImageCell", for: indexPath) as? ItemDetailCollectionViewCell else {return UICollectionViewCell()}
        
        let photo = itemPhotosArray[indexPath.row]
        cell.updateCell(with: photo)
    
        return cell
    }

}

extension ItemDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
           return 253
        }
        if indexPath.section == 1 {
            return 437
        }
        if indexPath.section == 2 {
            return 233
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailNameCell", for: indexPath) as? NameCell else { return UITableViewCell()}
            
            cell.updateNameCell(with: item, with: category)
            
            return cell
        }
        if indexPath.section == 1 {
             guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailDetailCell", for: indexPath) as? ItemInfoCell else { return UITableViewCell()}
            
            cell.updateCell(with: item)
            
            return cell
        }
        if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailNoteCell", for: indexPath) as? ItemDetailsCell else { return UITableViewCell()}
            
            cell.updateItemCell(with: item)
            
            return cell
        }
        return UITableViewCell()
    }
    
}
