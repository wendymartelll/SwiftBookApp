//
//  KBBooksDetailsViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import MapKit

class KBBooksDetailsViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var bookname: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var back: UILabel!
    @IBOutlet weak var smallMapView: MKMapView!
    var copyob: PFObject!
    var geopoint: PFGeoPoint!
    
    convenience init(koobBook: KoobBook) {
        self.init()
        copyob = koobBook.object
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookname.text = (copyob.objectForKey("BookName") as String)
        price.text = (copyob.objectForKey("Price") as String)
        author.text = (copyob.objectForKey("AuthorName") as String)
        condition.text = (copyob.objectForKey("Condition") as String)
        
        let theImage: PFFile? = (copyob.objectForKey("image") as? PFFile)
        
        let imageData: NSData = theImage!.getData()
        
        if (theImage == nil) {
            cover.image = UIImage(named: "wallb")
        } else {
            cover.image = UIImage(data: imageData)
        }
        
        back.backgroundColor = KBBooksDetailsViewController.isWallPixel(cover.image!, x: 200, y: 120)
        
        let thisBook: KoobBook = KoobBook(PFObject: copyob)
        
        let thisBookLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(thisBook.geopoint!.latitude, thisBook.geopoint!.longitude)
        
        if (thisBookLocation.latitude == 0 && thisBookLocation.longitude ==  0) {
            smallMapView.hidden = true
        } else {
            setupMapLayer()
            smallMapView.showAnnotations(NSArray(object: thisBook), animated: false)
        }
        
        scroll.delegate = self
    }
    
    func setupMapLayer() {
        let l: CALayer = smallMapView.layer
        
        l.masksToBounds = true
        l.cornerRadius = smallMapView.bounds.size.width / 4.0
        l.borderWidth = 4.0
        l.borderColor = UIColor(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0, alpha: 0.3).CGColor
        // TODO: find the bridge method
        //l.shadowColor = (UIColor.blueColor() as? CGColorRef)
        l.shadowOffset = CGSizeMake(10.0, 10.0)
    }
    
    class func isWallPixel(image: UIImage, x: Int, y: Int) -> UIColor {
        let pixelData: CFDataRef = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        let data = CFDataGetBytePtr(pixelData)
        
        let yTa: CGFloat = CGFloat(y)
        
        let pixelInfo = ((image.size.width * CGFloat(y)) + CGFloat(x)) * CGFloat(4)
        
        let red = CGFloat(data[Int(pixelInfo)])
        let green = CGFloat(data[Int(pixelInfo + 1)])
        let blue = CGFloat(data[Int(pixelInfo + 2)])
        let alpha = CGFloat(data[Int(pixelInfo + 3)])
        
        // do not need that
        //CFRelease(pixelData)
        
        let color: UIColor = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha/255.0) // the pixel color Info
        
        return color
    }
    
    @IBAction func makeCall(sender: AnyObject) {
        let bookSeller: PFObject = copyob["parent"] as PFObject
        
        bookSeller.fetchIfNeededInBackgroundWithBlock({(object: PFObject!, error:NSError!) in
            
            let phoneNumber: String = (bookSeller["mobile"] as String)
            
            UIApplication.sharedApplication().openURL(NSURL(string: "tell://\(phoneNumber)"))
        })
    }
    
    @IBAction func textMessage(sender: AnyObject) {
        let bookSeller: PFObject = copyob["parent"] as PFObject
        
        bookSeller.fetchIfNeededInBackgroundWithBlock({(object: PFObject!, error:NSError!) in
            
            let phoneNumber: String = (bookSeller["mobile"] as String)
            
            UIApplication.sharedApplication().openURL(NSURL(string: "sms:\(phoneNumber)"))
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "displayOnMainMap") {
            let destination = segue.destinationViewController as KBMapViewController
            destination.annotationToShow = KoobBook(PFObject: copyob)
        }
    }
    
    // MARK: Custom unwind segue
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scroll.contentOffset.y < 0) {
            performSegueWithIdentifier("swipeToClose", sender: self)
        }
    }
}