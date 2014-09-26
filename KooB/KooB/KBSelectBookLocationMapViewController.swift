//
//  KBSelectBookLocationMapViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import MapKit

protocol SelectBookLocationMapViewControllerDelegate {
    func userDidSelectLocation(location: CLLocationCoordinate2D, currentView:UIViewController, radius:Double)
}

class KBSelectBookLocationMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
}