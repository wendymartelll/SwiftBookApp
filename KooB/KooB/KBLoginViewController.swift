//
//  KBLoginViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/20/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class KBLoginViewController: UIViewController, UITextFieldDelegate, MBProgressHUDDelegate {
    var HUD: MBProgressHUD?
    var refreshHUD: MBProgressHUD?
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var containerView: UIView!
    var activeField: UITextField?
    var usernameFieldFinalPosition: CGPoint?
    var passwordFieldFinalPosition: CGPoint?
    var containerViewOriginalCenter: CGPoint?
    var labelsOnScreen: Bool = false
    
    override func viewWillAppear(animated: Bool) {
        usernameField.delegate = self
        passwordField.delegate = self
        usernameField.alpha = 0.0
        passwordField.alpha = 0.0
        registerForKeyboardNotifications()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        labelsOnScreen = false
        scrollView.userInteractionEnabled = false
        moveLabelsOffScreen()
        scalecontainerViewUp()
        super.viewDidAppear(animated)
    }
    
    func scalecontainerViewUp() {
        var expandedFrame = containerView.frame
        containerViewOriginalCenter = containerView.center
        expandedFrame.origin.y = view.center.y - expandedFrame.size.height / 2
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
            self.containerView.frame = expandedFrame
            self.containerView.transform = CGAffineTransformMakeScale(1.1, 1.1)
            }, completion: nil)
    }
    
    func scalecontainerViewDown() {
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
            self.containerView.center = self.containerViewOriginalCenter!
            self.containerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillBeHidden:", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue().size
        let buttonOrigin = activeField!.frame.origin
        let buttonHeight = activeField!.frame.size.height
        var visibleRect = view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if !CGRectContainsPoint(visibleRect, buttonOrigin) {
            let scrollPoint = CGPointMake(0, buttonOrigin.y - visibleRect.size.height + buttonHeight)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func moveLabelsOffScreen() {
        usernameFieldFinalPosition = usernameField.center
        passwordFieldFinalPosition = passwordField.center
        
        usernameField.center = CGPointMake(view.frame.size.width - usernameField.center.x, view.frame.size.height + usernameField.center.y)
        passwordField.center = CGPointMake(view.frame.size.width - passwordField.center.x, view.frame.size.height + passwordField.center.y)
        labelsOnScreen = false
    }
    
    func bringLabelsOnScreen() {
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
            self.usernameField.alpha = 1.0
            self.passwordField.alpha = 1.0
            
            self.usernameField.center = self.usernameFieldFinalPosition!
            self.passwordField.center = self.passwordFieldFinalPosition!
            }, completion: nil)
        
        labelsOnScreen = true
    }
    
    @IBAction func loginBtn(sender: AnyObject) {
        if !labelsOnScreen {
            bringLabelsOnScreen()
            scalecontainerViewDown()
        } else {
            let username = usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let password = passwordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            signIn(username, password: password)
        }
    }
    
    func signIn(username: String, password: String) {
        refreshHUD = MBProgressHUD(view: view)
        view.addSubview(refreshHUD!)
        refreshHUD?.delegate = self
        refreshHUD?.show(true)
        
        if username.isEmpty || password.isEmpty {
            refreshHUD?.hide(true)
            let alertView = UIAlertView(title: "Oops!", message: "Make sure you enter the Username and Password!", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        } else {
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user: PFUser!, error: NSError!) -> Void in
                if error != nil {
                    if self.refreshHUD != nil {
                        self.refreshHUD?.hide(true)
                    }
                    
                    let alertView = UIAlertView(title: "Sorry!", message:"There was an error executing your request. Please try again later.", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                } else {
                    if self.refreshHUD != nil {
                        self.refreshHUD?.hide(true)
                    }
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
}