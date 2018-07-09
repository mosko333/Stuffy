//
//  cameraPreviewViewController.swift
//  Stuffy
//
//  Created by Hayden Murdock on 6/27/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class cameraPreviewViewController: UIViewController {
    
    
    @IBOutlet weak var photo: UIImageView!
    
    var image: UIImage?
    var categoryPicked:CategoryCD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = image else { return }
        DispatchQueue.main.async {
            self.photo.image = image
        }
    }
    
    @IBAction func savePhotoButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addItemVC", sender: self)
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemVC" {
            let destinationVC = segue.destination as! NewAddItemTableViewController
            destinationVC.image = image
            destinationVC.categoryPicked = categoryPicked
        }
    }
}
