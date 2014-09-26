//
//  KBPageViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/20/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class KBPageViewController: UIViewController, UIPageViewControllerDelegate {
    var pageViewController: UIPageViewController?
    @IBOutlet internal weak var pageControl: UIPageControl!
    internal var modelController: KBPageModelController?
    
    override func viewDidLoad() {
        view.backgroundColor = nil
        modelController = KBPageModelController(initialViewControllerFromStoryboard: storyboard!)
        modelController?.parentController = self
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController?.delegate = self
        let startingViewController = modelController?.viewControllerAtIndex(0, storyboard: storyboard!)
        var viewControllers: NSArray = [startingViewController!]
        //pageViewController!.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        pageViewController!.dataSource = modelController
        addChildViewController(pageViewController!)
        if let parent = parentViewController {
            view.addSubview(parentViewController!.view)
        }
        var pageViewRect = view.bounds
        pageViewController!.view.frame = pageViewRect
        pageViewController!.didMoveToParentViewController(self)
        view.gestureRecognizers = pageViewController!.gestureRecognizers
        pageControl.numberOfPages = modelController!.numberOfViewControllers()
        viewDidLoad()
    }
    
    func updatePageControl(pageNumber: Int) {
        pageControl.currentPage = pageNumber
        pageControl.updateCurrentPageDisplay()
    }
}