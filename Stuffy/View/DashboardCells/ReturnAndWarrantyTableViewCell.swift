//
//  ReturnAndWarrantyTableViewCell.swift
//  Stuffy
//
//  Created by Adam on 19/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class ReturnAndWarrantyTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getUpCommingReturnDates() -> (date1: String,date2: String,date3: String){
        let items = CoreDataController.shared.items
        let closestDateItemArray = items.sorted { $0.lastDayToReturn! < $1.lastDayToReturn! }
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
       let date1 =  df.string(from: closestDateItemArray[0].lastDayToReturn ?? Date())
       let date2 = df.string(from: closestDateItemArray[1].lastDayToReturn ?? Date())
        let date3 = df.string(from: closestDateItemArray[2].lastDayToReturn ?? Date())
        
        return (date1,date2,date3)
        }
    func getUpCommingReturnItemNames() -> (item1Name: String, item2Name: String, item3Name: String){
        let items = CoreDataController.shared.items
        let closestDateItemArray = items.sorted { $0.lastDayToReturn! < $1.lastDayToReturn! }
    
        let item1Name =  closestDateItemArray[0].title ?? "None"
        let item2Name = closestDateItemArray[1].title ?? "None"
        let item3Name = closestDateItemArray[2].title ?? "None"
        
        return (item1Name, item2Name, item3Name)
        
    }
    
    func getUpCommingWarrantyDates() -> (date1: String,date2: String,date3: String){
        let items = CoreDataController.shared.items
        let closestDateItemArray = items.sorted { $0.warranty! < $1.warranty! }
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let date1 =  df.string(from: closestDateItemArray[0].lastDayToReturn ?? Date())
        let date2 = df.string(from: closestDateItemArray[1].lastDayToReturn ?? Date())
        let date3 = df.string(from: closestDateItemArray[2].lastDayToReturn ?? Date())
        
        return (date1,date2,date3)
    }
    
    func getUpComingWarrantyTitles()-> (item1Name: String, item2Name: String, item3Name: String){
        let items = CoreDataController.shared.items
        let closestDateItemArray = items.sorted { $0.warranty! < $1.warranty! }
        
        let item1Name =  closestDateItemArray[0].title ?? "None"
        let item2Name = closestDateItemArray[1].title ?? "None"
        let item3Name = closestDateItemArray[2].title ?? "None"
        
        return (item1Name, item2Name, item3Name)
        
    }
    
    
    
}
    

