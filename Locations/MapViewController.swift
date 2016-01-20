//
//  MapViewController.swift
//  Locations
//
//  Created by Sana Hassan on 1/20/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var didUpdateViewConstraints  = false
    var userLocation : CLLocationCoordinate2D!
    var storeLocation: Location!
    
    init(usrLocation: CLLocationCoordinate2D, strLocation: Location) {
        self.userLocation = usrLocation
        self.storeLocation = strLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateViewConstraints() {
        if (!didUpdateViewConstraints) {
            didUpdateViewConstraints = true
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["mapView" : self.mapView]))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["mapView" : self.mapView]))
        }
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = CLLocationCoordinate2D(
            latitude: self.storeLocation.latitude!,
            longitude: self.storeLocation.longitude!
        )
        annotation1.title = self.storeLocation.locationName
        mapView.addAnnotation(annotation1)
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = self.userLocation
        annotation2.title = "Your Location"
        mapView.addAnnotation(annotation2)
        
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title! == "Your Location" {
           var pinView = self.mapView.dequeueReusableAnnotationViewWithIdentifier("pinView")
            if (pinView == nil) {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinView")
                pinView?.canShowCallout = true
                if let pinView  = pinView as? MKPinAnnotationView {
                    pinView.pinTintColor = .blueColor()
                }
            }
            return pinView
        }
        return nil
    }
    
    private lazy var mapView : MKMapView = {
        let view = MKMapView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }()

}
