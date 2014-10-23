//
//  KoobBook.swift
//  KooB
//
//  Created by Andrea Borghi on 9/21/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import MapKit

enum Condition {
    case bad
    case good
    case average
}

class KoobBook: NSObject, MKAnnotation {
    var bookTitle: String = ""
    var author: String = ""
    var subject: String = ""
    var price: Double = 0.0
    var condition: Condition = .average
    
    // Location variables
    var coordinate: CLLocationCoordinate2D {
        get {
            return self.coordinate
        }
    }
    var radius: Double?
    var subtitle: String = ""
    
    // Parse variables
    var object: PFObject?
    var picture: PFImageView?
    var geopoint: PFGeoPoint?
    var user: PFUser?
    
    convenience init(title: String, author: String, price: Double) {
        self.init()
        self.bookTitle = title
        self.author = author
        self.price = price
    }
    
    convenience init (PFObject anObject: PFObject) {
        self.init()
        
        anObject.fetchIfNeeded()
        
        
        self.object = anObject

        // In \object\ there is no "user" key so get rid of it
        //self.user = (anObject.objectForKey("User") as? PFUser)
        
        
        // Since some entries in our database do not have some value - we have to check optionals
        if let tempGeopoint = (anObject.objectForKey("Location") as? PFGeoPoint) {
            self.geopoint = tempGeopoint
        } else {
            self.geopoint = PFGeoPoint(latitude: 0, longitude: 0)
        }
        if let tempBookName = (anObject.objectForKey("BookName") as? String) {
            self.bookTitle = tempBookName
        }

        if let tempSubtitle = (anObject.objectForKey("sellerName") as? String) {
            self.subtitle = tempSubtitle
        }

        if let tempAuthor = (anObject.objectForKey("AuthorName") as? String) {
            self.author = tempAuthor
        }

        // Condition?
        if let tempCondition = (anObject.objectForKey("Condition") as? String) {
            
            switch tempCondition {
                case "Like-New": self.condition = .good
                case "Heavily-Used": self.condition = .bad
                case "Average": self.condition = .average;
            default: self.condition = .average;
            }
        }
        
        if let tempPrice = (anObject.objectForKey("Price") as? Double) {
            self.price = tempPrice
        }
        if let tempSubject = (anObject.objectForKey("Subject") as? String) {
            self.subject = tempSubject
        }
        if let tempPicture = (anObject.objectForKey("image") as? PFImageView) {
            self.picture = tempPicture
        }
        if let tempRadius = (anObject.objectForKey("Radius") as? Double) {
            self.radius = tempRadius
        }

    }
    
    func getStringCondition() -> String {
        switch self.condition {
        case .bad: return "Heavily Used"
        case .good: return "Like New"
        case .average: return "Average"
        }
    }
}