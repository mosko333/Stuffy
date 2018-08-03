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
class AddItemTableViewController: UITableViewController {
    
    var pictureTaken = false
    var itemDetail = false
    let imagePicker = UIImagePickerController()
    
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
            if (item?.images?.count)! > 0 {
                pictureTaken = true
                image = getPhotoForThumbNail(with: item!)
                CoreDataController.shared.photos = getAllPhotosForItem(with: item!)
            }
        }
    }
    var image: UIImage? {
        didSet{
            print("image has been set")
            pictureTaken = true
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Checking to see if item is passed along
        if item != nil {
            itemDetail = true
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Image picker delgate functions
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
    
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 1
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && CoreDataController.shared.photos.count == 0  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewCameraCell", for: indexPath) as? CameraCell else {return UITableViewCell()}
            // setting up camera cell.
            cell.delegate = self
            cell.setupCaptureSession()
            cell.setupDevice()
            cell.setupInputOutput()
            cell.setupPreviewLayer()
            cell.startRunningCaptureSession()
            
            return cell
        }
        if indexPath.section == 0 && CoreDataController.shared.photos.count > 0   {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewCameraCell", for: indexPath) as? CameraCell else {return UITableViewCell()}
            // setting up camera cell after picture has been taken
            cell.delegate = self
            cell.thumbnailImage.image = CoreDataController.shared.photos.last
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
            // setting up name and category cell
             cell.backgroundColor = Colors.Grey
            cell.itemNameTextField.addDoneButtonOnKeyboard()
            cell.priceTextField.addDoneButtonOnKeyboard()
            cell.quantityTextField.text = "\(numberOfItems)"
            cell.priceTextField.keyboardType = .decimalPad
            cell.delegate = self
            // this where we update the custom cell if a category or item has been sent across. 
            cell.updateCell(with: categoryPicked)
            cell.updateCell(with: item)
            
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
        
        return 0
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // 1. We grab everything off the custom cells
        
        print("the category that the item will save as is : \(String(describing: categoryPicked?.name))")
        guard let categoypicked = categoryPicked else { return }
        let favorited = false
        guard let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? NameandCategoryCell else { return }
        guard let title = nameCell.itemNameTextField.text, title != "" else { return }
        print(title)
        let itemPrice = Double("\(nameCell.priceTextField.text ?? "")") ?? 0
        let quantity = Double(nameCell.quantityTextField.text!)
        
        let modelNumber = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M-d-yy"
        let purchaseDate = dateFormatter.date(from: "") ?? Date()

        let returnDate =  dateFormatter.date(from: "") ?? Date()
        let serialNumber =  ""
        let vendor =  ""
        let warranty = dateFormatter.date(from: "") ?? Date()
     
        let notes = ""
        
        let photos = CoreDataController.shared.photos
        // 2. we save item to Core Data
        
        CoreDataController.shared.createItem(category: categoypicked, photos: photos, title: title, isFavorited: favorited, lastDayToReturn: returnDate, modelNumber: modelNumber, notes: notes, price: itemPrice, purchasedFrom: vendor, quantity: quantity!, serialNumber: serialNumber, warranty: warranty, purchaseDate: purchaseDate)
        
        
        // 3. we remove all photos in arrays
        
       
        CoreDataController.shared.photos.removeAll()
        
        // 4. close camera Session and dissmiss_ Note to self, we could run a clean up of the arrays here in the completion. 
        self.dismiss(animated: true) {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewCameraCell") as! CameraCell
            cell.captureSession.stopRunning()
        }
       

    }
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
        print("Add Item table view has been dismissed")
        // Force closing the camera Session
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCameraCell") as! CameraCell
        cell.captureSession.stopRunning()
        
        // removing anything in the The photo arrays that might have been saved
        
        CoreDataController.shared.photos.removeAll()
        
    }
}

extension AddItemTableViewController: CameraDelegate, AVCapturePhotoCaptureDelegate {
    // what happens when we hit the photo button.
    func capturePhoto(_ cell: CameraCell) {
        cell.cameraButton.isUserInteractionEnabled = false
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 40,
                             kCVPixelBufferHeightKey as String: 40]
        settings.previewPhotoFormat = previewFormat
        
        cell.photoOutput?.capturePhoto(with: settings, delegate: self)
        cell.endRunningSession()
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNavControllerAutoCrop" {
            let destinationVC = segue.destination as! UINavigationController
            let topVC = destinationVC.topViewController as! AutoCropViewController
            topVC.categoryPicked = categoryPicked
            let cameraCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as!
            CameraCell
            cameraCell.endRunningSession()
        }
        
        if segue.identifier == "toCameraPreviewController" {
            let destinationVC = segue.destination as! cameraPreviewViewController
            destinationVC.image = image
            let cameraCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as!
            CameraCell
            cameraCell.endRunningSession()
        }
        if segue.identifier == "toCatDetailVC"{
            let cameraCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as!
            CameraCell
            cameraCell.endRunningSession()
            
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
            let image = UIImage(cgImage: cgImageRef, scale: 4, orientation: .right)


            CoreDataController.shared.photos.append(image)
            tableView.reloadData()
        }
    }
    
    func toPictureLibrary(_ cell: CameraCell) {
         present(imagePicker, animated: true)
        let cameraCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as!
        CameraCell
        cameraCell.endRunningSession()
    }
    
}


extension AddItemTableViewController: ChangeQuantityDelegate {
    
    func addItemQuantity(_ cell: NameandCategoryCell) {
        // function when we hit the plus button
        numberOfItems += 1
        print("one item has been added")
        
    }
    
    func minusItemQuantity(_ cell: NameandCategoryCell) {
        // function where we hit the minus button
         numberOfItems -= 1
        print("one item has been removed")
    }
}


extension AddItemTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Image picker logic. We set the thumbnail to the image that has been picked.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage
        guard let image = imagePicked else { return }
        CoreDataController.shared.photos.append(image)
        
        print("imagePickerController func called")
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("image picker has been canceled")
        dismiss(animated: true)
    }
    
    
}

extension AddItemTableViewController: UITextViewDelegate {
 // This is for the note cell so it can have a place holder text.
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let indexPath = IndexPath(row: 0, section: 3)
        let noteCell = tableView.cellForRow(at: indexPath) as! NotesCell
        
        noteCell.notesTextView.textColor = .black
        
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
        
        textView.resignFirstResponder()
    }
}

extension AddItemTableViewController {
    // These functions are for Item Detail Pictures.
    func getPhotoForThumbNail(with item: ItemCD) -> UIImage {
        
        guard let photos = item.images?.allObjects as? [ImageCD] else {return UIImage()}
        
        for photo in photos {
            let image = UIImage(data: photo.image!)
            let fixedPhoto = image?.fixedOrientation()
            return fixedPhoto!
        }
        return UIImage()
    }

    func getAllPhotosForItem(with item: ItemCD) -> [UIImage] {
        
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

