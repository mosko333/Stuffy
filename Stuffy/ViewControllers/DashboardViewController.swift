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
    @IBOutlet weak var warrantyTable: UITableView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        warrantyTable.delegate = self
        warrantyTable.dataSource = self
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

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            //return "Upcoming Return Dates"
            let backgroundView = UIView()
            backgroundView.backgroundColor = .white
            let underline = UIView()
            let title = UILabel()
            title.font = UIFont(name: "Avenir-Medium", size: 10)
            title.text = "Upcoming Return Dates"
            title.textColor = Colors.stuffyMedGray
            underline.backgroundColor = Colors.stuffyLightGray
            backgroundView.addSubview(title)
            backgroundView.addSubview(underline)
            title.translatesAutoresizingMaskIntoConstraints = false
            let labelTop = NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0)
            let labelLeft = NSLayoutConstraint(item: title, attribute: .leftMargin, relatedBy: .equal, toItem: backgroundView, attribute: .leftMargin, multiplier: 1, constant: 22)
            underline.translatesAutoresizingMaskIntoConstraints = false
            let underlineBottem = NSLayoutConstraint(item: underline, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: 0)
            let underlineLeft = NSLayoutConstraint(item: underline, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 22)
            let underlineRight = NSLayoutConstraint(item: underline, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -22)
            let underlineHeight = NSLayoutConstraint(item: underline, attribute: .height, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 0, constant: 1)
            backgroundView.addConstraints([labelTop, labelLeft, underlineBottem, underlineLeft, underlineRight, underlineHeight])
            return backgroundView
        }
        if section == 1 {
            //return "Upcoming Return Dates"
            let backgroundView = UIView()
            let title = UILabel()
            title.font = UIFont(name: "Avenir-Medium", size: 10)
            title.text = "Upcoming Warranty Expirations"
            title.textColor = Colors.stuffyMedGray
            backgroundView.addSubview(title)
            title.translatesAutoresizingMaskIntoConstraints = false
            let labelTop = NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0)
            let labelCenterX = NSLayoutConstraint(item: title, attribute: .leftMargin, relatedBy: .equal, toItem: backgroundView, attribute: .leftMargin, multiplier: 1, constant: 22)
            
            backgroundView.addConstraints([labelTop, labelCenterX])
            return backgroundView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.white
        let underline = UIView()
        backgroundView.addSubview(underline)
        underline.backgroundColor = Colors.stuffyOrange
        underline.translatesAutoresizingMaskIntoConstraints = false
        let underlineTop = NSLayoutConstraint(item: underline, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0)
        let underlineLeft = NSLayoutConstraint(item: underline, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 22)
        let underlineRight = NSLayoutConstraint(item: underline, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -22)
        let underlineHeight = NSLayoutConstraint(item: underline, attribute: .height, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 0, constant: 100)
        backgroundView.addConstraints([underlineTop, underlineLeft, underlineRight, underlineHeight])
        return backgroundView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell") as! DashboardTableViewCell
        
        return cell
    }
    
    
}
