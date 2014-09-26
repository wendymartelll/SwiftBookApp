//
//  KBMainViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class KBMainViewController: UIViewController {
    @IBOutlet weak var ScrollView: UIScrollView!
    var path: NSIndexPath?
    var categories = [String]?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScrollView.scrollEnabled = false
        //categories = bookListViewController.categories
        let koobLogo = UIImage(named: "Clean Logo Small")
        navigationItem.titleView = UIImageView(image: koobLogo)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() != nil {
            performSegueWithIdentifier("LoginScreen", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showTappedCategory" {
//            if self.path != nil {
//                //segue.destinationViewController.setCategory
//            } else {
//                
//            }
//        }
    }
    
    @IBAction func allBooksButtonTapped(sender: AnyObject) {
        self.path = nil
        self.performSegueWithIdentifier("showTappedCategory", sender: self)
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        return true
    }
    
//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String) -> UIStoryboardSegue {
//        KBSwipeToCloseSegue
//    }
}