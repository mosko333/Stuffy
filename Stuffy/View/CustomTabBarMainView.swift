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
    func addItemTabPressed()
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
    }
    
    @IBAction func tabBarBtnPressed(_ sender: UIButton) {
        
        if sender == tabBarButton3 {
            delegate?.addItemTabPressed()
            print("AddItem Btn Pressed")
            return
        }
        
        reset()
        switch sender {
        case tabBarButton1:
            sender.setImage(#imageLiteral(resourceName: "xcaHomeBarDark"), for: .normal)
        case tabBarButton2:
            sender.setImage(#imageLiteral(resourceName: "xcaFavBarDark"), for: .normal)
        case tabBarButton4:
            sender.setImage(#imageLiteral(resourceName: "xcaSearchMenuDark"), for: .normal)
        case tabBarButton5:
            sender.setImage(#imageLiteral(resourceName: "xcaUserMenuDark"), for: .normal)
        default:
            sender.setImage(#imageLiteral(resourceName: "xcaSampleImage"), for: .normal)
        }
        delegate?.tabBarViewChangedSelectedIndex(at: sender.tag)
    }
    
    func reset() {
        tabBarButton1.setImage(#imageLiteral(resourceName: "xcaHomeBarLight"), for: .normal)
        tabBarButton2.setImage(#imageLiteral(resourceName: "xcaFavBarLight"), for: .normal)
        tabBarButton4.setImage(#imageLiteral(resourceName: "xcaSearchMenuLight"), for: .normal)
        tabBarButton5.setImage(#imageLiteral(resourceName: "xcaUserMenuLight"), for: .normal)
    }
    
}
