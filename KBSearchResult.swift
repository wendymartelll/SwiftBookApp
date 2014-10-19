//
//  KBSearchResult.swift
//  KooB
//
//  Created by E on 10/3/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit


class KBSearchResult: UIViewController
{
    

    @IBOutlet var SearchWord:UILabel!
    var Search:String = ""
    
    override func viewDidLoad() {
        SearchWord.text = Search;
        
    }
    
    
}
