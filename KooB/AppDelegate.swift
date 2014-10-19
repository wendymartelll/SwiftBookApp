//
//  AppDelegate.swift
//  KooB
//
//  Created by Andrea Borghi on 9/20/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var booksOnMap: [KoobBook]?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //PFFacebookUtils.initializeFacebook()
        // Override point for customization after application launch.
        Parse.setApplicationId("JNhafPk76vP2VgQLa8RRnl78nfflQqkqx0ymGCM0", clientKey:"uEXBWmTyi9wpjRACN7gflO3ijcsgpWeYejXszoqv")
        setupNavigationBarGlobal()
        return true
    }
    
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
//        return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, withSession:PFFacebookUtils.session())
//    }
//    
//    func applicationDidBecomeActive(application: UIApplication) {
//        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
//    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setupNavigationBarGlobal() {
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().titleTextAttributes = titleDict
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor(red: 133.0/255.0, green: 216.0/255.0, blue: 208.0/255.0, alpha: 1)
    }
}