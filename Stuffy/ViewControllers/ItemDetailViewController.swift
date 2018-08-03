//
//  ItemDetailViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/25/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailViewController: UIViewController, UICollectionViewDataSource, UIPickerViewDelegate {
    
    
    var datePickerSetPurchaseDate = false
    var datePickerSetReturnDate = false
    var datePickerSetWarrantyDate = false
    
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
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
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
        }
    }
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension ItemDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 1
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
            
            cell.background4Picker.isHidden = true
            cell.vendorTextField.addDoneButtonOnKeyboard()
            cell.modelTextField.addDoneButtonOnKeyboard()
            cell.serialTextField.addDoneButtonOnKeyboard()
            cell.pickerView.layer.cornerRadius = 10
            cell.updateCell(with: item)
            cell.pickerView.frame.origin.y += 700
            cell.delegate = self
            
            return cell
        }
        if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailNoteCell", for: indexPath) as? ItemDetailNoteCell else { return UITableViewCell()}
            
            cell.updateCell(with: item)
            cell.notesTextView.addDoneButtonOnKeyboard()
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 43
        }
        return 0 
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // setting up header for third tableview
        if section == 1  {
            let superview = UIView()
            superview.backgroundColor = .white
            
            let button = UIButton(type: .system)
            
        
            button.setImage(#imageLiteral(resourceName: "xcaDownChevron"), for: .normal)
           
            button.backgroundColor = .white
            // button.addTarget(self, action: #selector(openCloseCell), for: .touchUpInside)
            button.contentMode = .center
            button.tag = 1
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            superview.addSubview(button)
            
            let buttonTop = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let buttonCenterX = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 150)
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
    
   
    func getPhotos(with item: ItemCD) -> [UIImage] {
        guard let photos = item.images?.allObjects as? [ImageCD] else {return [UIImage()]}
        var getPhotosArray: [UIImage] = []
        for photo in photos {
            let image = UIImage(data: photo.image!)
            getPhotosArray.append(image!)

        }

        return getPhotosArray
    }
    

    
}

extension ItemDetailViewController: PickerDelegate {
    
    func showPurchaseDatePicker(_ cell: ItemInfoCell) {
        print("show Purchase DatePicker button pressed")
        cell.background4Picker.isHidden = false
        datePickerSetPurchaseDate = true
        UIView.animate(withDuration: 0.4) {
            cell.pickerView.frame.origin.y -= 700
        }
    }
    
    func showReturnDatePicker(_ cell: ItemInfoCell) {
        print("show Return DatePicker button pressed")
        cell.background4Picker.isHidden = false
        datePickerSetReturnDate = true
        UIView.animate(withDuration: 0.4) {
            cell.pickerView.frame.origin.y -= 700
        }
    }
    
    func showWarrantyDatePicker(_ cell: ItemInfoCell) {
        print("show Warranty DatePicker button pressed")
        datePickerSetWarrantyDate = true
        cell.background4Picker.isHidden = false
        
        UIView.animate(withDuration: 0.4) {
            cell.pickerView.frame.origin.y -= 700
        }
    }
    
        func cancelButton(_ cell: ItemInfoCell) {
            
            if datePickerSetPurchaseDate == true {
                cell.purchaseDateLabel.text = ""
            }
            if datePickerSetReturnDate == true {
                
                cell.returnByDateLabel.text = ""
            }
            if datePickerSetWarrantyDate == true {
                
                cell.warrantyDateLabel.text = ""
            }
            
            cell.background4Picker.isHidden = true
            datePickerSetPurchaseDate = false
            datePickerSetWarrantyDate = false
            datePickerSetReturnDate = false
            
            UIView.animate(withDuration: 0.4) {
                cell.pickerView.frame.origin.y += 700
            }
        }
        
        func saveButton(_ cell: ItemInfoCell) {
            UIView.animate(withDuration: 0.5) {
                cell.pickerView.frame.origin.y += 700
            }
            datePickerSetWarrantyDate = false
            datePickerSetReturnDate = false
            datePickerSetPurchaseDate = false
            cell.background4Picker.isHidden = true
            
    }
        
        func dateChanged(_ cell: ItemInfoCell) {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = DateFormatter.Style.long
            
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateStyle = DateFormatter.Style.short
            dateFormatter2.dateFormat = "M/d/yy"
            
            if datePickerSetPurchaseDate == true {
                cell.purchaseDateLabel.isHidden = false
                let purchaseDate = dateFormatter1.string(from: cell.datePicker.date)
                cell.purchaseDateLabel.text = purchaseDate
                
            }
            if datePickerSetReturnDate == true {
                cell.returnByDateLabel.isHidden = false
                let returnDate = dateFormatter2.string(from: cell.datePicker.date)
                cell.returnByDateLabel.text = returnDate
                
            }
            
            if datePickerSetWarrantyDate == true {
                cell.warrantyDateLabel.isHidden = false
                let warrantyDate = dateFormatter2.string(from: cell.datePicker.date)
                cell.warrantyDateLabel.text = warrantyDate
            }
            cell.setDateButton.isUserInteractionEnabled = true
            saveButton.isEnabled = true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddItem" {
            guard let destinationVC = segue.destination as? UINavigationController else { return }
            guard let topVC = destinationVC.topViewController as? AddItemTableViewController else { return }
        
            topVC.item = item
            topVC.categoryPicked = item?.category
        }
    }
    
  func checkImage(_ image: UIImage) -> UIImage{
    if image.imageOrientation == .up {
        return image
    }
    if image.imageOrientation != .up {
       return image.fixedOrientation()
    }
    return UIImage()
    }
}


