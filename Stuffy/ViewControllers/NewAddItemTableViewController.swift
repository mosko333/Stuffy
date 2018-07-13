//
//  NewAddItemTableViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/2/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import AVFoundation

class NewAddItemTableViewController: UITableViewController {
    
    var pictureTaken = false
    var section2Open = false
    var categoryPicked: CategoryCD? {
        didSet{
            print("item category name is \(String(describing: categoryPicked?.name))")
        }
    }
    var isFavorited = false
    var numberOfItems = 1{
        didSet {
            print("There are \(numberOfItems)")
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
        }
    }
    var item: Item?
    var image: UIImage? {
        didSet{
            print("image has been set")
            pictureTaken = true
            tableView.reloadData()
        }
    }
    var receipt: UIImage? {
        didSet {
            print("receipt has been set")
        }
    }
    
    var datePickerSetPurchaseDate = false
    var datePickerSetReturnDate = false
    var datePickerSetWarrantyDate = false
    

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 1
        }
        if section == 2 && section2Open == false {
            return 0
        }
        if section == 2 && section2Open == true {
           return 1
        }
        if section == 3 {
            return 1
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && pictureTaken == false  {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewCameraCell", for: indexPath) as? NewCameraCell else {return UITableViewCell()}
        
        cell.delegate = self
        cell.setupCaptureSession()
        cell.setupDevice()
        cell.setupInputOutput()
        cell.setupPreviewLayer()
        cell.startRunningCaptureSession()
        
        return cell
        }
        
         if indexPath.section == 0 && pictureTaken ==  true {
             guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewCameraCell", for: indexPath) as? NewCameraCell else {return UITableViewCell()}
            
            cell.captureSession.stopRunning()
            cell.cameraPreviewLayer?.removeFromSuperlayer()
            cell.cameraPreviewLayer = nil
            cell.imageBackgroundView.isHidden = true
            
         // cell.imageBackgroundView.frame.size = CGSize(width: cell.frame.size.width * 0.30, height: cell.frame.size.width * 0.30)
            cell.thumbnailImage.frame.size = CGSize(width: cell.frame.size.width, height: cell.frame.size.width - 63)
            
            //cell.imageBackgroundView.center.x = cell.cameraView.center.x
           // cell.imageBackgroundView.center.y = cell.cameraView.center.y - 50
            
            cell.thumbnailImage.center.x =  cell.cameraView.center.x
            cell.thumbnailImage.center.y = cell.cameraView.center.y - 50
            
            
            cell.thumbnailImage.image = image
            
            return cell
            
        }
        
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameandCategoryCell", for: indexPath) as? NameandCategoryCell else {return UITableViewCell()}
             cell.backgroundColor = Colors.Grey
            
            cell.priceTextField.addDoneButtonOnKeyboard()
            let categoryName = categoryPicked?.name ?? ""
            cell.categoryNameLabel.text = categoryName
            cell.quantityTextField.text = "\(numberOfItems)"
            cell.priceTextField.keyboardType = .decimalPad
            cell.delegate = self
            return cell
        }
        
        if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemDetailCell", for: indexPath) as? ItemDetailsCell else {return UITableViewCell()}
            cell.datePickerView.backgroundColor = .white
            cell.datePickerView.layer.cornerRadius = 10 
            cell.datePickerView.frame.origin.y += 700
            cell.addDoneButton()
            cell.delegate = self
            return cell
        }
        if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NotesCell else {return UITableViewCell()}
            
            cell.backgroundColor = Colors.Grey
            cell.addDoneButton()
            return cell
        }
        
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       if  indexPath.section == 0 && pictureTaken == false{
           return 375
        }
        if indexPath.section == 0 && pictureTaken == true {
            return 223
        }
        if indexPath.section == 1{
         return 253
        }
        if indexPath.section == 2 && section2Open == false{
            return 0
        }
        if indexPath.section == 2 && section2Open == true {
            return 437
        }
        if indexPath.section == 3 {
            return 223
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 43
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // this will setup the headers for the item details and documents
        if section == 2 {
            let superview = UIView()
            superview.backgroundColor = .white
            
            
            let cheveronButton = UIButton(type: .system)
            cheveronButton.setTitle("Open", for: .normal)
            cheveronButton.setTitleColor(UIColor.black, for: .normal)
            cheveronButton.backgroundColor = .white
            cheveronButton.addTarget(self, action: #selector(openCloseCell), for: .touchUpInside)
            cheveronButton.contentMode = .center
            cheveronButton.tag = 1
            
            
            
            cheveronButton.translatesAutoresizingMaskIntoConstraints = false
            
            superview.addSubview(cheveronButton)
            
            let buttonTop = NSLayoutConstraint(item: cheveronButton, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let buttonCenterX = NSLayoutConstraint(item: cheveronButton, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 130)
            let buttonWidth = NSLayoutConstraint(item: cheveronButton, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.25, constant: 0)
            let buttonHeight = NSLayoutConstraint(item: cheveronButton, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 36)
            
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
            plusImage.image = UIImage(named: "xcaPlus")
            
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
        if section2Open == true  && button.tag == 1{
            
            section2Open = false
            let indexPath = IndexPath(row: 0, section: 2)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            button.setTitle("Open", for: .normal)
            
            print("closed itemDetailCell")
            
            // open Section
        } else if section2Open == false && button.tag == 1 {
            
            button.setTitle("Close", for: .normal)
            
            section2Open = true
            let indexPath = IndexPath(row: 0, section: 2)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            print("opened itemDetailCell")
            }
        }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        let id = image ?? #imageLiteral(resourceName: "xcaNoImage")
        let imageData = UIImagePNGRepresentation(id)
        guard let categoypicked = categoryPicked else { return }
        
        let rd = receipt  ?? #imageLiteral(resourceName: "xcaAdd")
        let receiptData = UIImagePNGRepresentation(rd)
        let favorited = isFavorited
       let nameCell = tableView.dequeueReusableCell(withIdentifier: "NameandCategoryCell") as! NameandCategoryCell
        guard let title = nameCell.itemNameTextField.text, title != "" else { return }
        let itemPrice = Double(nameCell.priceTextField.text!)
        let quantity = Double(nameCell.quantityTextField.text!)
        let itemCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! ItemDetailsCell
        let modelNumber = itemCell.modelTextField.text
        let dateFormatter = DateFormatter()
    
        let purchaseDate = dateFormatter.date(from:"\(itemCell.purchaseDateTextField.text ?? "")") ?? Date()
        let returnDate =  dateFormatter.date(from:"\(itemCell.returnDateTextField.text ?? "")") ?? Date()
        let serialNumber =  itemCell.serialTextField.text
        let vendor = itemCell.storeVenderTextField.text
        let warranty = itemCell.warrantyExpirationDateTextField.text
        
        let noteCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! NotesCell
        let notes = noteCell.notesTextView.text
        
        ItemCoreDataController.shared.createItem(category: categoypicked, title: title, receipt: receiptData!, image: imageData!, isFavorited: favorited, lastDayToReturn: returnDate, modelNumber: modelNumber!, notes: notes!, price: itemPrice!, purchasedFrom: vendor!, quantity: quantity!, serialNumber: serialNumber!, warranty: warranty!, purchaseDate: purchaseDate)

        
        
        print("item was created")
       
        let storyboard = UIStoryboard(name: "MyStuff", bundle: nil)
        let DV = storyboard.instantiateViewController(withIdentifier: "MyStuffNavigationController") as! UINavigationController
        let topVC = DV.topViewController as! MyStuffViewController
        topVC.categoryPicked = categoypicked
        present(DV, animated: true)
        
    }
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension NewAddItemTableViewController: CameraDelegate, AVCapturePhotoCaptureDelegate {
    
    func capturePhoto(_ cell: NewCameraCell) {
        let settings = AVCapturePhotoSettings()
        cell.photoOutput?.capturePhoto(with: settings, delegate: self )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowPhoto"{
            let previewVC = segue.destination as! cameraPreviewViewController
            previewVC.image = self.image
            previewVC.categoryPicked = categoryPicked
        }
        
        if segue.identifier == "toNavControllerAutoCrop" {
            let destinationVC = segue.destination as! UINavigationController
            let topVC = destinationVC.topViewController as! AutoCropViewController
            topVC.categoryPicked = categoryPicked
        }
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            print(imageData)
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "toShowPhoto", sender: self)
        }
    

    }
    
    func toPictureLibrary(_ cell: NewCameraCell) {
         present(imagePicker, animated: true)
    }
    
}


extension NewAddItemTableViewController: ChangeQuantityDelegate {
    func addItemQuantity(_ cell: NameandCategoryCell) {
        numberOfItems += 1
        print("one item has been added")
        
    }
    
    func minusItemQuantity(_ cell: NameandCategoryCell) {
         numberOfItems -= 1
        print("one item has been removed")
    }
    
    func openCategories(_ cell: NameandCategoryCell) {
        print("open categories button tapped")
    }
    
    
    
}


extension NewAddItemTableViewController: deleteItemDelegate {
    func deleteItem(_ cell: NotesCell) {
        print("Delete item button pressed")
        
    }
    
    
}

extension NewAddItemTableViewController: CustomDatePickerDelegate {
   
    
 
    
    func showPurchaseDatePicker(_ cell: ItemDetailsCell) {
        UIView.animate(withDuration: 0.5) {
            cell.datePickerView.frame.origin.y -= 700
        }
        datePickerSetPurchaseDate = true
       print("purchase date picker button pushed")
        cell.saveButton.backgroundColor = Colors.Grey
        cell.saveButton.isUserInteractionEnabled = false
    }
    
    func showReturnDatePicker(_ cell: ItemDetailsCell) {
        
        UIView.animate(withDuration: 0.5) {
            cell.datePickerView.frame.origin.y -= 700
        }
        datePickerSetReturnDate = true
        print("return date picker button pushed")
        cell.saveButton.backgroundColor = Colors.Grey
        cell.saveButton.isUserInteractionEnabled = false
    }
    
    func showWarrantyDatePicker(_ cell: ItemDetailsCell) {
        UIView.animate(withDuration: 0.5) {
            cell.datePickerView.frame.origin.y -= 700
        }
        datePickerSetWarrantyDate = true
        print("warranty date picker button pushed")
        cell.saveButton.backgroundColor = Colors.Grey
        cell.saveButton.isUserInteractionEnabled = false
    }
    
    func cancelButton(_ cell: ItemDetailsCell) {
        
        if datePickerSetPurchaseDate == true {
           
            cell.purchaseDateLabel.text = ""
            
            
        }
        if datePickerSetReturnDate == true {
           
            cell.returnDateLabel.text = ""
            
        }
        
        if datePickerSetWarrantyDate == true {
            
            cell.warrantyExpirationDateLabe.text = ""
        }
        
        datePickerSetWarrantyDate = false
        datePickerSetReturnDate = false
        datePickerSetPurchaseDate = false
        
    
        UIView.animate(withDuration: 0.5) {
            cell.datePickerView.frame.origin.y += 700
        }
    }
    
    func saveButton(_ cell: ItemDetailsCell) {
        UIView.animate(withDuration: 0.5) {
            cell.datePickerView.frame.origin.y += 700
        }
        datePickerSetWarrantyDate = false
        datePickerSetReturnDate = false
        datePickerSetPurchaseDate = false
        
    }
    
    func dateChanged(_ cell: ItemDetailsCell) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "M/d/yy"
        if datePickerSetPurchaseDate == true {
            cell.purchaseDateLabel.isHidden = false
            let purchaseDate = dateFormatter.string(from: cell.datePicker.date)
            cell.purchaseDateLabel.text = purchaseDate
            
        }
        if datePickerSetReturnDate == true {
            cell.returnDateLabel.isHidden = false
            let returnDate = dateFormatter.string(from: cell.datePicker.date)
            cell.returnDateLabel.text = returnDate
            
        }
        
        if datePickerSetWarrantyDate == true {
            cell.warrantyExpirationDateLabe.isHidden = false
            let warrantyDate = dateFormatter.string(from: cell.datePicker.date)
            cell.warrantyExpirationDateLabe.text = warrantyDate
        }
        cell.saveButton.backgroundColor = .blue
        cell.saveButton.isUserInteractionEnabled = true
    }
    
}

extension NewAddItemTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
       // pickedImage.image = image
        print("imagePickerController func called")
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("image picker has been canceled")
        dismiss(animated: true)
    }
    
    
}
