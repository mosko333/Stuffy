//
//  addItemTableViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/26/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class addItemTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, addNewCategoryDelegate {
 
    
    
    let catagories: [String] = ["Unassigned", "Home", "Office", "Garage"]
    

    var isSection0Open = true
    var isSection1Open = true
    var isSection2Open = true
    var isSection3Open = false
    var isSection4Open = false
    var isSection5Open = true
    var itemCategory = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = Colors.Grey
      
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // This is for first Section
        if section == 0 && isSection0Open == true {
            return 1
        }
        if section == 0 && isSection0Open == false {
            return 0
        }
        // This is for second section
        if section == 1 && isSection1Open == true {
            return 1
        }
        if section == 1 && isSection1Open == false {
            return 0
        }
        // This is for the 3rd Section
        if section == 2 && isSection2Open == true {
            return 1
        }
        if section == 2 && isSection2Open == false {
            return 0
        }
        // This is for the 4th Section
    
        if section == 3 && isSection3Open == true {
            return 1
        }
        if section == 3 && isSection3Open == false {
            return 0
        }
        // This is for the 5th Section
        if section == 4 && isSection4Open == true {
            return 1
        }
        if section == 4 && isSection4Open == false {
            return 0
        }
        //This is for the 6th Section
        if section == 5 && isSection5Open == true {
            return 1
        }
        if section == 5 && isSection5Open == false {
            return 0
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "cameraCell", for: indexPath) as? CameraCell else {return UITableViewCell()}
            cell.backgroundColor = Colors.Grey
            
            
            return cell
        }
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as? Name_CategoryCell else {return UITableViewCell()}
            cell.backgroundColor = Colors.Grey
            cell.delegate = self
            cell.addCategoryButton.frame.size = CGSize(width: view.frame.width * 0.9, height: 40)
            cell.nameTextField.frame.size = CGSize(width: view.frame.width * 0.9, height: 40)
            cell.categoryPicker.delegate = self
            cell.categoryPicker.dataSource = self
            
            
            return cell
        }
       
        if indexPath.section == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as? Notes_SaveCell else {return UITableViewCell()}
            cell.backgroundColor = Colors.Grey
            cell.notesTextView.text = "Add Notes"
            cell.notesTextView.frame.size = CGSize(width: view.frame.width * 0.9, height: 168)
            
            cell.saveButton.frame.size = CGSize(width: view.frame.width * 0.9, height: 61)

            cell.saveButton.backgroundColor = UIColor.blue
        
            cell.saveButton.titleLabel?.text = "Save"
            cell.notesTextView.layer.shadowColor = UIColor.black.cgColor
            cell.notesTextView.layer.shadowRadius = 4
            cell.notesTextView.layer.shadowOpacity = 0.25
            cell.notesTextView.layer.masksToBounds = false
            cell.notesTextView.clipsToBounds = false
        

            
            
            return cell
       
       
    }
        return UITableViewCell()
    }
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
        return 374
        }
        if indexPath.section == 1 {
            return 225
        }
        if indexPath.section == 2 {
            return 150
        }
        if indexPath.section == 3 {
            return 150
        }
        if indexPath.section == 4 {
            return 150
        }
        if indexPath.section == 5 {
            return 275
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 3 {
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
            let labelCenterX = NSLayoutConstraint(item: itemDetailsLabel, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: -130)
            let labelWidth = NSLayoutConstraint(item: itemDetailsLabel, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.25, constant: 0)
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
        
        if section == 4 {
            let superview = UIView()
            superview.backgroundColor = .white
            
            let cheveronButton = UIButton(type: .system)
            cheveronButton.setTitle("Open", for: .normal)
            cheveronButton.setTitleColor(UIColor.black, for: .normal)
            cheveronButton.backgroundColor = .white
            cheveronButton.addTarget(self, action: #selector(openCloseCell), for: .touchUpInside)
            cheveronButton.contentMode = .bottom
            cheveronButton.tag = 2
            
            
            
            cheveronButton.translatesAutoresizingMaskIntoConstraints = false
            
            superview.addSubview(cheveronButton)
            
            let buttonTop = NSLayoutConstraint(item: cheveronButton, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let buttonCenterX = NSLayoutConstraint(item: cheveronButton, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 150)
            let buttonWidth = NSLayoutConstraint(item: cheveronButton, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.25, constant: 0)
            let buttonHeight = NSLayoutConstraint(item: cheveronButton, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 36)
            
            superview.addConstraints([buttonTop, buttonCenterX, buttonWidth, buttonHeight])
            
            
            let documentsLabel = UILabel()
            documentsLabel.text = "Documents"
            documentsLabel.font =  UIFont(name: "Avenir", size: 18)
            documentsLabel.textColor = .black
            
            superview.addSubview(documentsLabel)
            
            documentsLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let labelTop = NSLayoutConstraint(item: documentsLabel, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            let labelCenterX = NSLayoutConstraint(item: documentsLabel, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: -130)
            let labelWidth = NSLayoutConstraint(item: documentsLabel, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 0.25, constant: 0)
            let labelHeight = NSLayoutConstraint(item: documentsLabel, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0, constant: 36)
            
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
        if isSection3Open == true  && button.tag == 1{
            
            isSection3Open = false
            let indexPath = IndexPath(row: 0, section: 3)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            button.setTitle("Open", for: .normal)
            
            print("closed itemDetailCell")
            
            // open Section
        } else if isSection3Open == false && button.tag == 1 {
            
            button.setTitle("Close", for: .normal)
            
            isSection3Open = true
            let indexPath = IndexPath(row: 0, section: 3)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            print("opened itemDetailCell")
        }
        
        if isSection4Open == true  && button.tag == 2{
            
            isSection4Open = false
            let indexPath = IndexPath(row: 0, section: 4)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            button.setTitle("Open", for: .normal)
            
            
            print("closed documentsCell")
            // open Section
        } else if isSection4Open == false && button.tag == 2 {
            
            button.setTitle("Close", for: .normal)
            
            isSection4Open = true
            let indexPath = IndexPath(row: 0, section: 4)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            print("openend documentsCell")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 63
        }
        if section == 4 {
            return 63
        }
        return 0
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catagories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return catagories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.itemCategory = catagories[row]
        print("item's category is \(itemCategory)")
    }
    func animateNewCategoryView(_ cell: Name_CategoryCell) {
        print("add newCategory button tapped")
    
    }

}
