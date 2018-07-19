//
//  StartCheckScreenViewController.swift
//  Stuffy
//
//  Created by Adam on 17/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class StartCheckScreenViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserStatus()
    }
    
    func checkUserStatus() {
        if !isKeyPresentInUserDefaults(key: "SeenOnbourdingScreen") {
            defaults.set(true, forKey: "SeenOnbourdingScreen")
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "OnboardPageControlViewController") as! OnboardPageControlViewController
            UIApplication.shared.keyWindow?.rootViewController = viewController
        } else if defaults.string(forKey: "Pin")?.count == 4 {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "PinPad", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "PinPadViewController") as! PinPadViewController
            viewController.actionWanted = .login
            UIApplication.shared.keyWindow?.rootViewController = viewController
        } else {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CustomTabBarViewContoller") as! CustomTabBarViewController
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}


