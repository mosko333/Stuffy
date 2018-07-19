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
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CustomTabBarViewContoller") as! CustomTabBarViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    //        UIApplication.shared.keywindo
    
    //        if defaults.bool(forKey: "SeenOnbourdingScreen") != true {
    //            defaults.set(true, forKey: "SeenOnbourdingScreen")
    //            //self.present
    //            if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "ToOnboarding") {
    //                self.present(presentedViewController, animated: true, completion: nil)
    //            }
    //        } else if defaults.string(forKey: "Pin")?.count == 4 {
    //            // go to pin
    //        } else {
    //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //            let presentedViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarViewContoller")
    //            self.present(presentedViewController, animated: true)
    //        }
    //        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PinPadViewController")
    //
    //        self.present(mainStoryboard, animated: true, completion: nil)
    //        let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "CustomTabBarViewContoller") as! UITabBarController
    //        self.present(vc, animated: true, completion: nil)
    //        vc.selectedIndex = 0
    //        let detailNavCont = vc.selectedViewController as! UINavigationController
    //        let detailVC = detailNavCont.topViewController as! CategoriesViewController
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMain" {
            print("We are segueing?!?! ")
        }
    }
}
//             self.performSegue(withIdentifier: "ToMain", sender: self)


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ToPin" {
//            if let destinationVC = segue.destination as? PinPadViewController {
//                destinationVC.actionWanted = .login
//            }
//        }
//        if segue.identifier == "ToMain" {
//            if let destinationVC = segue.destination as? CategoriesViewController
//        }
//        if segue.identifier == "ToOnboarding" {
//            if let destinationVC = segue.destination as? OnboardingPageViewController
//        }
//    }


