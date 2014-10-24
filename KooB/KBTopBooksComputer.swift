//
//  KBTopBooksComputer.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation

class KBTopBooksComputer {

    var topBooks = [KoobBook]()
    let categories: [String]
    
    init(categories:[String]) {
        self.categories = categories
    }
    
//    func getTopBooksAsync(completionBlock:(topBooks:[KoobBook])->Void) {
//        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//        dispatch_async(dispatch_get_global_queue(priority, 0), { () -> Void in
//            self.getTopBooksFromDatabase()
//        })
//        
//        //completionBlock(topBooks: topBooks)
//        completionBlock(topBooks: self.topBooks)
//    }
    
    func getTopBooksAsync(completionBlock:(topBooks:[KoobBook])->Void) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.getTopBooksFromDatabase()
            
        dispatch_async(dispatch_get_main_queue()) {
        completionBlock(topBooks: self.topBooks)
            }
        }
    }
    
    func getTopBooksFromDatabase() {
        for categoryName in categories {
            queryForTopBook(category: categoryName)
        }
    }
    
    func queryForTopBook(#category: String) {
        let query = PFQuery(className: "Books_DataBase")
        query.whereKey("Subject", equalTo: category)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            if error == nil {
                var currentBook = KoobBook(PFObject: object)

                self.topBooks.append(currentBook)
                // Notification?
            } else {
                println("Can not Find any book")
            }
        }
    }
}