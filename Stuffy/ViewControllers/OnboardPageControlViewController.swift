//
//  OnboardPageControlViewController.swift
//  Stuffy
//
//  Created by John Hancock on 7/16/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class OnboardPageControlViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onboardingPageViewController = segue.destination as? OnboardingPageViewController {
            onboardingPageViewController.onboardingDelegate = self as? OnboardingPageViewControllerDelegate
        }
    }
}

extension OnboardPageControlViewController: OnboardingPageViewControllerDelegate {
    func onboardingPageViewController(onboardinPageViewController: OnboardingPageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func onboardingPageViewController(onboardingPageViewController: OnboardingPageViewController, didUPdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}
