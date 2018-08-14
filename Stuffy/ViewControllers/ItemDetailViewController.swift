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
    
    var section1isOpen = false
    var photosOfItem: [UIImage] = []
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
        guard let item = item else {return}
        category = item.category
        photosOfItem = getPhotos(with: item)
    
        itemDetailCollectionView.backgroundColor = Colors.stuffyBackgroundGray
        itemDetailCollectionView.delaysContentTouches = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemDetailCollectionView.dataSource = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    // CollectionView fuctions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return item?.images?.count ?? 0
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = itemDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailImageCell", for: indexPath) as? ItemDetailCollectionViewCell else {return UICollectionViewCell()}
        let photo = photosOfItem[indexPath.row]
        
        cell.updateCell(with: photo)
        if indexPath.row == 0{
            cell.coverPhotoButton.setTitleColor(Colors.stuffyOrange, for: .normal)
        } else {
            cell.coverPhotoButton.setTitleColor(UIColor.white, for: .normal)
        }
      
    
        return cell
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            print("Item Detail ViewController Dissmissed")
        }
    }
}

extension ItemDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        if section == 1 && section1isOpen == true {
            return 1
        }
        if section == 1 && section1isOpen == false {
            return 0
        }
        if section == 2 {
            return 1
        }
        return 0
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
             guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemInfoCell", for: indexPath) as? ItemInfoCell else { return UITableViewCell()}
            
            cell.updateCell(with: item)
            
            return cell
        }
        if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailNoteCell", for: indexPath) as? ItemDetailNoteCell else { return UITableViewCell()}
            
            cell.updateCell(with: item)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // setting up header for third tableview
        if section == 1  {
            let superview = UIView()
            superview.backgroundColor = .white
            
            let button = UIButton(type: .system)
            
            if section1isOpen == true {
                button.setImage(#imageLiteral(resourceName: "xcaDownChevron"), for: .normal)
            } else {
                button.setImage(#imageLiteral(resourceName: "xcaUpChevron"), for: .normal)
            }
            
            button.backgroundColor = .white
            button.addTarget(self, action: #selector(openCloseCell), for: .touchUpInside)
            button.contentMode = .center
            button.tag = 1
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            superview.addSubview(button)
            
            let buttonTop = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let buttonCenterX = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 130)
            let buttonWidth = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.25, constant: 0)
            let buttonHeight = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 36)
            
            superview.addConstraints([buttonTop, buttonCenterX, buttonWidth, buttonHeight])
            
            
            let itemDetailsLabel = UILabel()
            itemDetailsLabel.text = "Item Details"
            itemDetailsLabel.font = UIFont(name: "Avenir", size: 18)
            itemDetailsLabel.textColor = .black
            
            superview.addSubview(itemDetailsLabel)
            itemDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let labelTop = NSLayoutConstraint(item: itemDetailsLabel, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let labelCenterX = NSLayoutConstraint(item: itemDetailsLabel, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 0.60, constant: 0)
            let labelWidth = NSLayoutConstraint(item: itemDetailsLabel, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.50, constant: 0)
            let labelHeight = NSLayoutConstraint(item: itemDetailsLabel, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 36)
            
            superview.addConstraints([labelTop, labelCenterX, labelWidth, labelHeight])
            
            let plusImage = UIImageView()
            plusImage.image = UIImage(named: "xcabluePlusIcon")
            
            superview.addSubview(plusImage)
            
            plusImage.translatesAutoresizingMaskIntoConstraints = false
            
            let plusTop = NSLayoutConstraint(item: plusImage, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 12)
            let plusCenterX = NSLayoutConstraint(item: plusImage, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 0.05, constant: 0)
            let plusWidth = NSLayoutConstraint(item: plusImage, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0, constant: 12)
            let plusHeight = NSLayoutConstraint(item: plusImage, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 12)
            
            superview.addConstraints([plusTop, plusCenterX, plusWidth, plusHeight])
            
            
            return superview
        }
        return UIView()
    }
    
    @objc func openCloseCell(_ button: UIButton){
        
        if section1isOpen == true {
            section1isOpen = false
            let indexPath = IndexPath(row: 0, section: 1)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("closed itemDetailCell")
            
        } else {
            section1isOpen = true
            
            let indexPath = IndexPath(row: 0, section: 1)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
            print("opened itemDetailCell")
        }
    }
    func getPhotos(with item: ItemCD) -> [UIImage] {
        guard let photos = item.images?.allObjects as? [ImageCD] else {return [UIImage()]}
        var getPhotosArray: [UIImage] = []
        for photo in photos {
            let image = UIImage(data: photo.image!)
            let fixedPhoto = image?.fixedOrientation()
            getPhotosArray.append(fixedPhoto!)

        }

        return getPhotosArray
    }
    
}

extension ItemDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddItem" {
            guard let destinationVC = segue.destination as? UINavigationController else { return }
            guard let topVC = destinationVC.topViewController as? AddItemTableViewController else { return }
        
            topVC.item = item
            topVC.categoryPicked = item?.category
        }
    }
}

