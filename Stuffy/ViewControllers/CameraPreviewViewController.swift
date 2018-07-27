//
//  cameraPreviewViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/27/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class cameraPreviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
  
    
    var image: UIImage?
    var categoryPicked:CategoryCD?
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return CoreDataController.shared.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! CameraPreviewCollectionViewCell
        let photo = CoreDataController.shared.photos[indexPath.row]
        cell.collectionViewPhotoThumbnail.image = photo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = CoreDataController.shared.photos[indexPath.row]
        self.image = image
        
        tableView.reloadData()
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CameraPreviewTableViewCell", for: indexPath) as! CameraPreviewTableViewCell
        
        cell.imagePicked.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 424
    }
    
    
    
    @IBAction func savePhotoButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addItemVC", sender: self)
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemVC" {
            let destinationVC = segue.destination as! UINavigationController
           let topVC = destinationVC.topViewController as! AddItemTableViewController
            topVC.image = image
            topVC.categoryPicked = categoryPicked
        }
    }
    
    
}
