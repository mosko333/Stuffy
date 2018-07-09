//
//  PhotoPreviewViewController.swift
//  Stuffy
//
//  Created by Adam on 03/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//
import UIKit

class PhotoPreviewViewController: UIViewController {
    
    //////////////////////
    // TODO: Replace With Model
    //////////////////////
    var photo: UIImage?
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem) {
       performSegue(withIdentifier: "toNewAddItemVC", sender: self)
        
        print("recepit save button pressed")
        
    }
    
    func updateView() {
        //////////////////////
        // TODO: Replace
        //////////////////////
        DispatchQueue.main.async {
            self.photoImageView.image = self.photo
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewAddItemVC"{
            guard let destinationVC = segue.destination as? NewAddItemTableViewController else {return}
            destinationVC.receipt = photo
        }
    }
    
}
