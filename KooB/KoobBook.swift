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
        
        object = anObject
        
        if let point = anObject.objectForKey("Location") as? PFGeoPoint {
            geopoint = point
        }
        
        if let user = anObject.objectForKey("User") as? PFUser {
            self.user = user
        }
        
        if let title = anObject.objectForKey("BookName") as? String {
            self.title = title
        }
        
        if let subtitle = anObject.objectForKey("sellerName") as? String {
            self.subtitle = subtitle
        }
        
        if let author = anObject.objectForKey("AuthorName") as? String {
            self.author = author
        }
        
        if let price = anObject.objectForKey("Price") as? Double {
            self.price = price
        }
        
        if let subject = anObject.objectForKey("Subject") as? String {
            self.subject = subject
        }
        
        if let picture = anObject.objectForKey("image") as? PFImageView {
            self.picture = picture
        }
        
        if let radius = anObject.objectForKey("Radius") as? Double {
            self.radius = radius
        }
    }
}