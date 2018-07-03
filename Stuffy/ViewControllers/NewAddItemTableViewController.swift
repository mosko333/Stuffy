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

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
            cell.imageBackgroundView.isHidden = false
            
          //  cell.imageBackgroundView.frame.size = CGSize(width: cell.frame.size.width * 0.30, height: cell.frame.size.width * 0.30)
           // cell.thumbnailImage.frame.size = CGSize(width: cell.frame.size.width * 0.25, height: cell.frame.size.width * 0.25)
            
            //cell.imageBackgroundView.center.x = cell.cameraView.center.x
           // cell.imageBackgroundView.center.y = cell.cameraView.center.y - 50
            
            //cell.thumbnailImage.center.x =  cell.cameraView.center.x
           // cell.thumbnailImage.center.y = cell.cameraView.center.y - 50
            
            
            cell.thumbnailImage.image = image
            
            return cell
            
        }
        
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameAndCategoryCell", for: indexPath) as? NameandCategoryCell else {return UITableViewCell()}
             cell.backgroundColor = Colors.Grey
            cell.priceTextField.addDoneButtonOnKeyboard()
            cell.quantityTextField.text = "\(numberOfItems)"
            cell.priceTextField.keyboardType = .decimalPad
            cell.delegate = self
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
        if indexPath.section == 2 {
            return 150
        }
        if indexPath.section == 3 {
            return 150
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
            cheveronButton.contentMode = .bottom
            cheveronButton.tag = 1
            
            
            
            cheveronButton.translatesAutoresizingMaskIntoConstraints = false
            
            superview.addSubview(cheveronButton)
            
            let buttonTop = NSLayoutConstraint(item: cheveronButton, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let buttonCenterX = NSLayoutConstraint(item: cheveronButton, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 150)
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
            plusImage.image = UIImage(named: "plus")
            
            superview.addSubview(plusImage)
            
            plusImage.translatesAutoresizingMaskIntoConstraints = false
            
            let plusTop = NSLayoutConstraint(item: plusImage, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 12)
            let plusCenterX = NSLayoutConstraint(item: plusImage, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: -190)
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
    }

extension NewAddItemTableViewController: CameraDelegate, AVCapturePhotoCaptureDelegate {
    func capturePhoto(_ cell: NewCameraCell) {
        let settings = AVCapturePhotoSettings()
        cell.photoOutput?.capturePhoto(with: settings, delegate: self )
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            print(imageData)
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "toShowPhoto", sender: self)
        }
    }


override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toShowPhoto"{
        let previewVC = segue.destination as! cameraPreviewViewController
        previewVC.image = self.image
        }
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
