//
//  OnboardingPageViewController.swift
//  Stuffy
//
//  Created by John Hancock on 7/16/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    weak var onboardingDelegate: OnboardingPageViewControllerDelegate?

    private ( set ) lazy var orderedViewControllers: [UIViewController] = {
        return [self.getViewController(withIdentifier: "1"), self.getViewController(withIdentifier: "2"), self.getViewController(withIdentifier: "3")]
    }()
    
    private func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        onboardingDelegate?.onboardingPageViewController(onboardinPageViewController: self, didUpdatePageCount: orderedViewControllers.count)
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        guard orderedViewControllers.count > previousIndex else { return nil }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else { return nil }
        
        guard orderedViewControllersCount > nextIndex else { return nil }
        
        return orderedViewControllers[nextIndex]
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            onboardingDelegate?.onboardingPageViewController(onboardingPageViewController: self, didUPdatePageIndex: index)
        }
    }
}

protocol OnboardingPageViewControllerDelegate: class {
    func onboardingPageViewController(onboardinPageViewController: OnboardingPageViewController, didUpdatePageCount count: Int)
    
    func onboardingPageViewController(onboardingPageViewController: OnboardingPageViewController, didUPdatePageIndex index: Int)
}












