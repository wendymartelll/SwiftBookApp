//
//  KBMapViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import MapKit

class KBMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var location = CLLocation?()
    var filterDistance = CLLocationAccuracy?()
    var annotationShowed: Bool = false
    var annotationToShow: MKAnnotation?
    var booksOnMap: [KoobBook]? = []
    
    func setAnnotationToShow(annotation: MKAnnotation) {
        annotationToShow = annotation
        annotationShowed = false
    }
    
    func openWithNoAnnotation() {
        annotationShowed = true
    }
    
    override func viewDidLoad() {
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        
        // Running iOS8
        if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Authorized {
                locationManager.requestWhenInUseAuthorization()
            }
        }
        
        if let loc = location? {
            println("Location is set")
        } else {
            location = locationManager.location
        }
        
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        booksOnMap = delegate.booksOnMap
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        locationManager.startUpdatingLocation()
        // query
        
        if let books = booksOnMap? {
            mapView.addAnnotations(books as NSArray)
        }
        
        if !annotationShowed {
            centerOnAnnotationToShow(animated: false)
        } else if mapView.annotations.count == 0 {
            centerOnUserLocation(animated: false)
        } else {
            mapView.showAnnotations(mapView.annotations, animated: false)
        }
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
        super.viewWillDisappear(animated)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        location = locations.last as? CLLocation
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation!.isEqual(mapView.userLocation as MKAnnotation) {
            return nil
        }
        
        let reuseID = "KoobBookAnnotationView"
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        
        if view != nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            view.canShowCallout = true
            let imageView = UIImageView(frame: CGRectMake(0, 0, 46, 46))
            view.leftCalloutAccessoryView = imageView
            let disclosureButton = UIButton()
            disclosureButton.setBackgroundImage(UIImage(named: "disclosure"), forState: .Normal)
            disclosureButton.sizeToFit()
            view.rightCalloutAccessoryView = disclosureButton
            let img = UIImage(named: "Mustache Pin")
            let imgToData = UIImagePNGRepresentation(img)
            view.image = UIImage(data: imgToData)
        }
        
        view.annotation = annotation
        return view
    }
    
//    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
//        for annotationView in views {
//            if annotationView.isKindOfClass(MKUserLocation) {
//                continue
//            }
//            let endFrame = annotationView.frame
//            annotationView.frame = CGRectOffset(endFrame, 0, -500)
//            
//        }
//    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        updateLeftCalloutAccessoryView(view)
    }
    
    func updateLeftCalloutAccessoryView(annotationView: MKAnnotationView) {
        var imageView: UIImageView?
        
        if annotationView.leftCalloutAccessoryView.isKindOfClass(UIImageView) {
            imageView = annotationView.leftCalloutAccessoryView as? UIImageView
        }
        
        if let view = imageView? {
            var book: KoobBook?
            
            if annotationView.annotation.isKindOfClass(KoobBook) {
                book = annotationView.annotation as? KoobBook
            }
            
            if let book = book? {
                let picture = book.picture
                
                if picture == nil {
                    imageView?.image = UIImage(named: "grey")
                } else {
                    let bookAsObject = book.object
                    let theImage = bookAsObject?.objectForKey("image")! as PFFile
                    let imageData = theImage.getData()
                    imageView?.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    func centerOnAnnotationToShow(#animated: Bool) {
        if let annotation = annotationToShow? {
            mapView.showAnnotations(NSArray(object: annotationToShow!), animated: animated)
            annotationShowed = true
        }
    }
    
    func centerOnUserLocation(#animated: Bool) {
        let viewRegion = MKCoordinateRegionMakeWithDistance(location!.coordinate, 1000, 1000)
        let adjustedRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: animated)
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        performSegueWithIdentifier("showBook", sender: view)
    }
    
    func prepareViewController(viewController: AnyObject, forSegue segue: String, toShowAnnotation annotation: MKAnnotation) {
        var book: KoobBook?
        
        if annotation.isKindOfClass(KoobBook) {
            book = annotation as? KoobBook
        }
        
        if book != nil {
            if !segue.isEmpty || segue == "showBook" {
                var bdvc = viewController as KBBooksDetailsViewController
                //bdvc.copyobj
                bdvc.title = book?.title
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender!.isKindOfClass(MKAnnotationView) {
            prepareViewController(segue.destinationViewController, forSegue: segue.identifier!, toShowAnnotation: (sender? as MKAnnotationView).annotation!)
        }
    }
    
    @IBAction func centerOnUserLocationButtonPressed(sender: AnyObject) {
        mapView.addAnnotations(booksOnMap)
        centerOnUserLocation(animated: true)
    }
}