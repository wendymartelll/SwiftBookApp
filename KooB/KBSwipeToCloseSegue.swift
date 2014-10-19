//
//  KBSwipeToCloseSegue.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation

class KBSwipeToCloseSegue: UIStoryboardSegue {
    var targetPoint: CGPoint?
    
    override func perform() {
        let sourceViewController = self.sourceViewController as UIViewController
        let destinationViewController = self.destinationViewController as UIViewController
        sourceViewController.view.superview?.insertSubview(destinationViewController.view, atIndex: 0)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            sourceViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05)
            sourceViewController.view.center = self.targetPoint!
        }) { (finished) -> Void in
            destinationViewController.view.removeFromSuperview()
            sourceViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}