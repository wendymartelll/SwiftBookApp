//
//  KBPresentDetailsViewSegue.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation

class KBPresentDetailsViewSegue: UIStoryboardSegue {
    var originatingPoint: CGPoint?
    
    override func perform() {
        let sourceViewController = self.sourceViewController as UIViewController
        let destinationViewController = self.destinationViewController as UIViewController
        sourceViewController.parentViewController?.view.addSubview(destinationViewController.view)
        destinationViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05)
        let originatingCenter = destinationViewController.view.center
        destinationViewController.view.center = originatingPoint!
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            destinationViewController.view.center = originatingCenter
        }) { (finished) -> Void in
            destinationViewController.view.removeFromSuperview()
            sourceViewController.navigationController?.pushViewController(destinationViewController, animated: false)
        }
    }
}