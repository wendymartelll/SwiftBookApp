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
    var title: String = ""
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
        self.geopoint = (anObject.objectForKey("Location") as? PFGeoPoint)
        self.user = (anObject.objectForKey("User") as? PFUser)
        self.title = (anObject.objectForKey("BookName") as String)
        self.subtitle = (anObject.objectForKey("sellerName") as? String)!
        self.author = (anObject.objectForKey("AuthorName") as String)
        // Condition?
        self.price = (anObject.objectForKey("Price") as Double)
        self.subject = (anObject.objectForKey("Subject") as String)
        self.picture = (anObject.objectForKey("image") as PFImageView)
        self.radius = (anObject.objectForKey("Radius") as Double)
    }
}