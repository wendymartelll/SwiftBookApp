//
//  KBTopBookCellViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation

class KBTopBookCellViewController: UIViewController {
    class func imageForBook(#book: KoobBook, completionBlock:(image: UIImage)->()) {
        let bookAsObject = book.object
        let theImage = bookAsObject!.objectForKey("image") as PFFile
        theImage.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            println("Get data in background with block called")
            
            if error == nil {
                completionBlock(image: UIImage(data: imageData)!)
            }
        }
    }
}