//
//  CustomUINavigationBar.swift
//  Stuffy
//
//  Created by Adam on 14/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class CustomUINavigationBar: UINavigationBar {
    
    //set NavigationBar's height
    @IBInspectable var customHeight : CGFloat = 86
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: customHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //
        //        print("It called")
        //
        //        self.tintColor = Colors.stuffyNavyBlue
        //        self.backgroundColor = .red
        
        
        
        for subview in self.subviews {
            var stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("UIBarBackground") {
                
                subview.frame = CGRect(x: 0, y: -20, width: self.frame.width, height: customHeight)
                
                subview.backgroundColor = Colors.stuffyNavyBlue
                subview.sizeToFit()
            }
            
            stringFromClass = NSStringFromClass(subview.classForCoder)
            
            //Can't set height of the UINavigationBarContentView
            if stringFromClass.contains("UINavigationBarContentView") {
                
                //Set Center Y
                //let centerY = (customHeight - subview.frame.height) / 2.0 - 20
                subview.frame = CGRect(x: 0, y: 9, width: self.frame.width, height: subview.frame.height)
                subview.backgroundColor = Colors.stuffyNavyBlue
                subview.sizeToFit()
            }
        }
    }
}
