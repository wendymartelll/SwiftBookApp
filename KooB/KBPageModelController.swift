//
//  KBPageModelController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/23/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class KBPageModelController: NSObject, UIPageViewControllerDataSource {
    var parentController: KBPageViewController?
    var pages:[UIViewController] = []
    
    convenience init(initialViewControllerFromStoryboard storyboard: UIStoryboard) {
        self.init()
        let viewController: AnyObject! = storyboard.instantiateViewControllerWithIdentifier("Page Content View Controller")
        pages.append(viewController as UIViewController)
        let viewController2: AnyObject! = storyboard.instantiateViewControllerWithIdentifier("Page Content View Controller 2")
        pages.append(viewController2 as UIViewController)
    }
    
    func viewControllerAtIndex(index: Int, storyboard:UIStoryboard) -> UIViewController? {
        if pages.isEmpty || index >= pages.count {
            return nil
        }
        return pages[index]
    }
    
    func indexOfViewController(viewController: UIViewController) -> Int? {
        return find(pages, viewController) // Same as Index of Object in Objective-C arrays
    }
    
    func numberOfViewControllers() -> Int {
        return pages.count
    }
    
     func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        if index != nil && index == 0 {
            updateParentControllerPageControlToIndexOfViewController(indexOfViewController(viewController)!)
            return nil
        }
        --index!
        updateParentControllerPageControlToIndexOfViewController(indexOfViewController(viewController)!)
        return viewControllerAtIndex(index!, storyboard: viewController.storyboard!)
    }
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        if index != nil && index == 0 {
            updateParentControllerPageControlToIndexOfViewController(indexOfViewController(viewController)!)
            return nil
        }
        ++index!
        if index == pages.count {
            updateParentControllerPageControlToIndexOfViewController(indexOfViewController(viewController)!)
            return nil
        }
        updateParentControllerPageControlToIndexOfViewController(indexOfViewController(viewController)!)
        return viewControllerAtIndex(index!, storyboard: viewController.storyboard!)
    }
    
    internal func updateParentControllerPageControlToIndexOfViewController(index: Int) {
        if parentController != nil {
            parentController?.updatePageControl(index)
        }
    }
}