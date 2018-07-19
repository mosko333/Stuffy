//
//  StartCheckScreenViewController.swift
//  Stuffy
//
//  Created by Adam on 17/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class StartCheckScreenViewController: UIViewController {
    
    struct Constants {
        static let isPinActiveKey = "isPinActive"
        static let onboardingKey = "Onboarding"
    }
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserStatus()
    }
    
    func checkUserStatus() {
        // Takes them to the onboarding screen on first login
        if UserDefaults.standard.object(forKey: Constants.onboardingKey) != nil {
            defaults.set(true, forKey: Constants.onboardingKey)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "OnboardPageControlViewController") as! OnboardPageControlViewController
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
        // Takes you to the pin pad if it's password is required
        else if UserDefaults().object(forKey: Constants.isPinActiveKey) as? Bool == true {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "PinPad", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "PinPadViewController") as! PinPadViewController
            viewController.actionWanted = .login
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
        // Moves to the main storyboard if onboarding has been done and no password required
        else {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CustomTabBarViewContoller") as! CustomTabBarViewController
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
    }
}
