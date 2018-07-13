//
//  CustomTabBarViewController.swift
//  Stuffy
//
//  Created by Adam on 26/06/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController, CustomTabBarViewMainDelegate {
    
    @IBOutlet weak var tabView: CustomTabBarMainView!
    
    override var selectedIndex: Int {
        didSet {
            //  tabView.setAppearance(forIndex: selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.delegate = self
        selectedIndex = 0
        tabView.addShadow()
        view.addSubview(tabView)
        
        let leadingConstraint = tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottomConstraint = tabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 34.0) //to extend behind the iPhone X home indicator
        let heightConstraint = tabView.heightAnchor.constraint(equalToConstant: 104.0) //includes 34.0 points for iPhone X home indicator
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, bottomConstraint, heightConstraint])
    }
    
    // MARK: - Custom Tab Bar Delegate
    
    func tabBarViewChangedSelectedIndex(at index: Int) {
        selectedIndex = index
    }
    
    func addItemTabPressed() {
        // TODO - Do Model segue here to addItem screen
        let storyBoard = UIStoryboard(name: "AddItem", bundle: nil)
        let destinationVC = storyBoard.instantiateViewController(withIdentifier: "AddItemNavController") as! UINavigationController
        present(destinationVC, animated: true)
        print("Present AddItem modelly here")
    }
    
    func setupView() {
        
//        guard let items = tabBar.items else { return }
//        let firstTab = items[0]
//        firstTab.selectedImage = #imageLiteral(resourceName: "xca6")
//        firstTab.image = #imageLiteral(resourceName: "xca7")

    }
    
}
