//
//  KBTabBarController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/20/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class KBTabBarController: UITabBarController {
    override func viewDidLoad() {
        UITabBar.appearance().barTintColor = UIColor(red: 133.0/255.0, green: 216.0/255.0, blue: 208.0/255.0, alpha: 1)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        super.viewDidLoad()
    }
}