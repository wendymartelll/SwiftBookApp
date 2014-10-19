//
//  KBSignupViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/20/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class KBSignupViewController: UIViewController, UITextFieldDelegate, MBProgressHUDDelegate {
    var HUD: MBProgressHUD
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        emailField.delegate = self
        mobileField.delegate = self
    }
    
    @IBAction func signupBtn(sender: AnyObject) {
        
        var username = usernameField.text
        username.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        var email = emailField.text
        email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        var mobile = mobileField.text
        mobile.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        var password = passwordField.text
        password.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if username.isEmpty || password.isEmpty || email.isEmpty {
            
            let alert = UIAlertView(title: "Oops!", message: "Make sure you enter ALL the information! Mobile is optional.", delegate: nil, cancelButtonTitle: "OK")
            
            alert.show()
            
        } else {
            
            var newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            // other fields can be set just like with PFObject
            newUser["mobile"] = mobile
            
            newUser.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error != nil {
                    let errorString = error.userInfo!["error"] as NSString
                    let alert2 = UIAlertView(title: "Sorry!", message: errorString, delegate: nil, cancelButtonTitle: "OK")
                    alert2.show()
                    
                } else {
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    let parent = self.presentingViewController as KBLoginViewController
                    parent.signIn(username, password: password)
                }
            }
        }
    }
    
    @IBAction func fbBtn(sender: AnyObject) {
        
        let permissionsArray = ["user_about_me", "user_relationships", "user_birthday", "user_location","email"]
        
        PFFacebookUtils.logInWithPermissions(permissionsArray, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
                
                let alert3 = UIAlertView(title: "Log In Error", message: "Uh oh. The user cancelled the Facebook login.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Dismiss")
                
                alert3.show()
                
                
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                
                //pop to main view
                
                self.HUD = MBProgressHUD(view: self.view)
                self.view.addSubview(self.HUD)
                self.HUD.mode = MBProgressHUDModeIndeterminate
                self.HUD.delegate = self
                self.HUD.labelText = ""
                self.HUD.show(true)
                
            } else {
                NSLog("User logged in through Facebook!")
                
                self.navigationController?.popToRootViewControllerAnimated(true)
                
                self.HUD = MBProgressHUD(view: self.view)
                self.view.addSubview(self.HUD)
                self.HUD.mode = MBProgressHUDModeIndeterminate
                self.HUD.delegate = self
                self.HUD.labelText = ""
                self.HUD.show(true)
            }
        })
        
    }
    
    @IBAction func cancelBtn(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}