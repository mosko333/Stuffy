//
//  CustomTabBarMainView.swift
//  Stuffy
//
//  Created by Adam on 26/06/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

protocol  CustomTabBarViewMainDelegate:class {
    func tabBarViewChangedSelectedIndex(at index: Int)
}

class CustomTabBarMainView: UIView {
    
    struct Constants {
        static let shadowRadius: CGFloat = 4.0
        static let grayRatio: CGFloat = 200/255
        static let shadowOffset = CGSize(width: 0, height: -5)
        static let shadowOpacity: Float = 0.5
    }
    
    @IBOutlet weak var backCircleView: UIView!
    @IBOutlet weak var tabViewBackgroundView: UIView!
    
    @IBOutlet weak var tabBarButton1: UIButton!
    @IBOutlet weak var tabBarButton2: UIButton!
    @IBOutlet weak var tabBarButton3: UIButton!
    @IBOutlet weak var tabBarButton4: UIButton!
    @IBOutlet weak var tabBarButton5: UIButton!
    
    weak var delegate: CustomTabBarViewMainDelegate?
    
    func addShadow() {
        backCircleView.layer.shadowColor = UIColor(red: Constants.grayRatio, green: Constants.grayRatio, blue: Constants.grayRatio, alpha: 1).cgColor
        backCircleView.layer.shadowRadius = Constants.shadowRadius
        backCircleView.layer.shadowOffset = Constants.shadowOffset
        backCircleView.layer.shadowOpacity = Constants.shadowOpacity
        
        tabViewBackgroundView.layer.shadowColor = UIColor(red: Constants.grayRatio, green: Constants.grayRatio, blue: Constants.grayRatio, alpha: 1).cgColor
        tabViewBackgroundView.layer.shadowRadius = Constants.shadowRadius
        tabViewBackgroundView.layer.shadowOffset = Constants.shadowOffset
        tabViewBackgroundView.layer.shadowOpacity = Constants.shadowOpacity
        
        tabBarButton1.setImage(#imageLiteral(resourceName: "xcaHouse"), for: .normal)
        tabBarButton2.setImage(#imageLiteral(resourceName: "xcaHeart"), for: .normal)
        tabBarButton4.setImage(#imageLiteral(resourceName: "xcaSearch"), for: .normal)
        tabBarButton5.setImage(#imageLiteral(resourceName: "xcaUser"), for: .normal)
    }
    
    @IBAction func tabBarBtnPressed(_ sender: UIButton) {
        delegate?.tabBarViewChangedSelectedIndex(at: sender.tag)
    }
    
}
