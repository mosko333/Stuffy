//
//  NewAddItemTableViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/2/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
class NewAddItemTableViewController: UITableViewController {
    var pictureTaken = false
    var section2Open = false
    var itemDetail = false
    var datePickerSetPurchaseDate = false
    var datePickerSetReturnDate = false
    var datePickerSetWarrantyDate = false
    var isFavorited = false
    let imagePicker = UIImagePickerController()
    var adamsIdea: String = ""
    var testPhotosArray: [UIImage] = []
    var categoryPicked: CategoryCD? {
        didSet{
            print("item category name is \(String(describing: categoryPicked?.name))")
        }
    }
    
    var numberOfItems = 1 {
        didSet {
            print("There are \(numberOfItems)")
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
        }
    }
    var item: ItemCD? {
        didSet {
            print("Item was pushed along. Showing Detail on \(String(describing: item?.title))")
        
        }
    }
    var image: UIImage? {
        didSet{
            print("image has been set")
            pictureTaken = true
            tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if item != nil {
            itemDetail = true
        }
        tableView.reloadData()
    }
    
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
        
        if indexPath.section == 0 && pictureTaken == false && itemDetail == false  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewCameraCell", for: indexPath) as? NewCameraCell else {return UITableViewCell()}
            
            cell.delegate = self
            cell.setupCaptureSession()
            cell.setupDevice()
            cell.setupInputOutput()
            cell.setupPreviewLayer()
            cell.startRunningCaptureSession()
            
            return cell
        }
        if indexPath.section == 0 && pictureTaken ==  true  && itemDetail == false {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewCameraCell", for: indexPath) as? NewCameraCell else {return UITableViewCell()}
            cell.delegate = self
            cell.thumbnailImage.image = image
            cell.setupCaptureSession()
            cell.setupDevice()
            cell.setupInputOutput()
            cell.setupPreviewLayer()
            cell.startRunningCaptureSession()
            cell.cameraButton.isUserInteractionEnabled = true
    
            return cell
        }
        
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameandCategoryCell", for: indexPath) as? NameandCategoryCell else {return UITableViewCell()}
             cell.backgroundColor = Colors.Grey
            cell.itemNameTextField.addDoneButtonOnKeyboard()
            cell.priceTextField.addDoneButtonOnKeyboard()
            cell.quantityTextField.text = "\(numberOfItems)"
            cell.priceTextField.keyboardType = .decimalPad
            cell.delegate = self
            cell.updateCell(with: categoryPicked)
            cell.updateCell(with: item)
            
            return cell
        }
        
        if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemDetailCell", for: indexPath) as? ItemDetailsCell else {return UITableViewCell()}
            cell.delegate = self
            cell.datePickerView.layer.cornerRadius = 10 
            cell.datePickerView.frame.origin.y += 700
            cell.datePicker.backgroundColor = .white
            cell.updateItemCell(with: item)
            cell.addDoneButton()

            return cell
        }
        
        if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NotesCell else {return UITableViewCell()}
            cell.delegate = self
            cell.backgroundColor = Colors.Grey
            cell.addDoneButton()
            cell.setupNotesCell()
            cell.notesTextView.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       if  indexPath.section == 0 {
           return 375
        }
        if indexPath.section == 1{
         return 253
        }
        if indexPath.section == 2 {
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
        if section == 2  {
            let superview = UIView()
            superview.backgroundColor = .white
        
            let button = UIButton(type: .system)
            
            if section2Open == true {
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
        
        if section2Open == true {
            section2Open = false
            let indexPath = IndexPath(row: 0, section: 2)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("closed itemDetailCell")
          
        } else {
            section2Open = true
            
            let indexPath = IndexPath(row: 0, section: 2)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
    
            print("opened itemDetailCell")
            }
        }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        // FIXME: - Return out of this function if the user doesn't have everything necessary to save an item
        print("the category that the item will save as is : \(String(describing: categoryPicked?.name))")
        guard let categoypicked = categoryPicked else { return }
        let favorited = isFavorited
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! NameandCategoryCell
        guard let title = nameCell.itemNameTextField.text, title != "" else { return }
        print(title)
        let itemPrice = Double("\(nameCell.priceTextField.text ?? "")") ?? 0
        let quantity = Double(nameCell.quantityTextField.text!)
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "itemDetailCell") as! ItemDetailsCell
        let modelNumber = itemCell.modelNumberTextField.text ?? ""
        let dateFormatter = DateFormatter()
        
        let purchaseDate = dateFormatter.date(from:"\(itemCell.purchaseDateTextField.text ?? "")") ?? Date()
        let returnDate =  dateFormatter.date(from:"\(itemCell.returnDateTextField.text ?? "")") ?? Date()
        let serialNumber =  itemCell.serialTextField.text ?? ""
        let vendor = itemCell.storeVenderTextField.text ?? ""
        let warranty = itemCell.warrantyExpirationDateTextField.text ?? ""
        
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! NotesCell
        let notes = noteCell.notesTextView.text ?? ""
        
        CoreDataController.shared.createItem(category: categoypicked, title: title, isFavorited: favorited, lastDayToReturn: returnDate, modelNumber: modelNumber, notes: notes, price: itemPrice, purchasedFrom: vendor, quantity: quantity!, serialNumber: serialNumber, warranty: warranty, purchaseDate: purchaseDate)
        
        let item = ItemCD(title: title, isFavorited: favorited, modelNumber: modelNumber, notes: notes, price: itemPrice, purchasedFrom: vendor, quantity: quantity!, serialNumber: serialNumber, warranty: warranty, purchaseDate: purchaseDate, lastDayToReturn: returnDate)
        
        for photo in CoreDataController.shared.photos {
            
            CoreDataController.shared.createImage(item: item, image: photo)
            testPhotosArray.append(photo)
            print(testPhotosArray.count)
        }
        CoreDataController.shared.photos.removeAll()
        
        print("item was created")
        
      self.dismiss(animated: true, completion: nil)

       

    }
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension NewAddItemTableViewController: CameraDelegate, AVCapturePhotoCaptureDelegate {
    
    func capturePhoto(_ cell: NewCameraCell) {
        cell.cameraButton.isUserInteractionEnabled = false
        let settings = AVCapturePhotoSettings()
        
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        cell.photoOutput?.capturePhoto(with: settings, delegate: self)
        
        cell.endRunningSession()
       
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNavControllerAutoCrop" {
            let destinationVC = segue.destination as! UINavigationController
            let topVC = destinationVC.topViewController as! AutoCropViewController
            topVC.categoryPicked = categoryPicked
        }
        
        if segue.identifier == "toCameraPreviewController" {
            let destinationVC = segue.destination as! cameraPreviewViewController
            destinationVC.image = image
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
           
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
            
            self.image = image

            CoreDataController.shared.photos.append(image)
           
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
            
            cell.warrantyExpirationDateLabel.text = ""
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
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = DateFormatter.Style.short
        dateFormatter1.timeStyle = DateFormatter.Style.short
        dateFormatter1.dateFormat = "M/d/yy"
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = DateFormatter.Style.long
        if datePickerSetPurchaseDate == true {
            cell.purchaseDateLabel.isHidden = false
            let purchaseDate = dateFormatter1.string(from: cell.datePicker.date)
            cell.purchaseDateLabel.text = purchaseDate
            
        }
        if datePickerSetReturnDate == true {
            cell.returnDateLabel.isHidden = false
            let returnDate = dateFormatter1.string(from: cell.datePicker.date)
            cell.returnDateLabel.text = returnDate
            
        }
        
        if datePickerSetWarrantyDate == true {
            cell.warrantyExpirationDateLabel.isHidden = false
            let warrantyDate = dateFormatter2.string(from: cell.datePicker.date)
            cell.warrantyExpirationDateLabel.text = warrantyDate
        }
        cell.saveButton.backgroundColor = .blue
        cell.saveButton.isUserInteractionEnabled = true
    }
    
}

extension NewAddItemTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        print("imagePickerController func called")
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("image picker has been canceled")
        dismiss(animated: true)
    }
    
    
}
extension NewAddItemTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            print("reached bottom")
             let cell = tableView.dequeueReusableCell(withIdentifier: "NewCameraCell") as! NewCameraCell
            cell.captureSession.stopRunning()
        }
        
        if (scrollView.contentOffset.y <= 0){
            //reach top
        }
        
        if (scrollView.contentOffset.y > 200 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewCameraCell") as! NewCameraCell
            cell.captureSession.stopRunning()
            print("scroll view print statement")
        }
    }
    
}

extension NewAddItemTableViewController: UITextViewDelegate {
 
    func textViewDidBeginEditing(_ textView: UITextView) {
        let indexPath = IndexPath(row: 0, section: 3)
        let noteCell = tableView.cellForRow(at: indexPath) as! NotesCell
        
        noteCell.notesTextView.textColor = .black
        
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
        
        textView.resignFirstResponder()
    }
}
