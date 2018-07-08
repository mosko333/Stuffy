//
//  DashboardViewController.swift
//  Stuffy
//
//  Created by Adam on 07/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    //////////////////////
    // MARK: Properties
    //////////////////////
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var numberOfCatLabel: UILabel!
    @IBOutlet var returnItemNameLabel: [UILabel]!
    @IBOutlet var returnItemDateLabel: [UILabel]!
    @IBOutlet weak var warrentyNameLabel: UILabel!
    @IBOutlet weak var warrentyDateLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        // TODO - Populate Views using search data
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
