//
//  KBTopBooksComputer.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation

class KBTopBooksComputer {
    var count: Int {
        didSet {
            println("The array is now \(count)")
            NSNotificationCenter.defaultCenter().postNotificationName(BookCoverDownloaded, object: nil)
        }
    }
    
    var topBooks = [KoobBook]()
    let categories: [String]
    
    init(categories:[String]) {
        self.categories = categories
        count = 0
    }
    
    func getTopBooksAsync(completionBlock:(topBooks:[KoobBook]) -> Void) {
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            for categoryName in self.categories {
                self.queryForTopBook(category: categoryName)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                completionBlock(topBooks: self.topBooks)
                NSNotificationCenter.defaultCenter().postNotificationName(BookCoverDownloaded, object: nil)
            }
        }
    }
    
    func queryForTopBook(#category: String) {
        let query = PFQuery(className: "Books_DataBase")
        query.whereKey("Subject", equalTo: category)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            if error == nil {
                var currentBook = KoobBook(PFObject: object)
                self.topBooks.append(currentBook)
                self.count++
                println("Found a book for \(category)")
            } else {
                println("Cannot find any book for \(category)")
            }
        }
    }
}