//
//  LocationResultsController.swift
//  Locations
//
//  Created by Sana Hassan on 1/19/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreLocation

class LocationResultsController: UITableViewController, CLLocationManagerDelegate  {

    var items = [Location]()
    var locationManager : CLLocationManager!
    //Defaulting to downtown Chicago!
    var userLocation = CLLocationCoordinate2D(latitude: 41.882030, longitude: -87.627889)
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    init() {
        super.init(style: UITableViewStyle.Plain)
        self.locationManager = CLLocationManager()
        self.locationManager.requestWhenInUseAuthorization()
        self.title = "Locations"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("showActionSheet"))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        RequestService().requestLocations(self.userLocation,
            onSuccess: { result -> Void in
                if result.count > 0 {
                    self.items += result
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            }, onFailure: { (error) -> Void in
                print(error)
            })
    }
    
    func configureTableView() {
        self.tableView.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView()
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100 //Estimated for dynamic cells
    }
    
    func showActionSheet() {
        let optionMenu = UIAlertController(title: "Sort By", message: nil, preferredStyle: .ActionSheet)
        
        let sortByName = UIAlertAction(title: "Name", style: .Default, handler: {(alert: UIAlertAction!) -> Void in
            self.items.sortInPlace({$0.locationName < $1.locationName})
            self.tableView.reloadData()
        })
        let sortByDistance = UIAlertAction(title: "Distance", style: .Default, handler: {(alert: UIAlertAction!) -> Void in
            for var location in self.items {
                let storeLocation = CLLocation(latitude: location.latitude!, longitude: location.longitude!)
                let userLocation = CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                location.updateDistance(storeLocation.distanceFromLocation(userLocation))
                self.items.sortInPlace({$0.distance < $1.distance})
                self.tableView.reloadData()
            }
        })
        let sortByArrivalTime = UIAlertAction(title: "Arrival Time", style: .Default, handler: {(alert: UIAlertAction!) -> Void in
            self.items.sortInPlace({$0.arrivalTime!.compare($1.arrivalTime!) == .OrderedAscending})
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        optionMenu.addAction(sortByName)
        optionMenu.addAction(sortByDistance)
        optionMenu.addAction(sortByArrivalTime)
        optionMenu.addAction(cancelAction)
        
        self.view.window?.rootViewController?.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func didBecomeActive() {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            } else if CLLocationManager.authorizationStatus() == .Denied {
                let alert = UIAlertController(title: "Oops!", message:"To get \"Distance from Current Location\" please authorize the app to use your current location.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default) { _ in
                    UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.view.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! CustomTableViewCell
        cell.layoutMargins = UIEdgeInsetsZero
        
        let loc = self.items[indexPath.row]
        cell.updateWithLocation(loc)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let signInViewController:MapViewController = MapViewController(usrLocation: self.userLocation, strLocation: self.items[indexPath.row])
        let navigationController = UINavigationController(rootViewController: signInViewController)
        navigationController.modalTransitionStyle = .CoverVertical
        navigationController.modalPresentationStyle =  .CurrentContext
        signInViewController.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "modalCancelled"), animated: true)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func modalCancelled() {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = manager.location!.coordinate
        print("locations = \(self.userLocation.latitude) \(self.userLocation.longitude)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        switch (error.code)  {
        case CLError.Denied.rawValue :
            print("User didn't authorize location updates!")
        case CLError.LocationUnknown.rawValue :
            print("Location Unknown")
            print("Developer! Enable the location by clicking the \"Simulate Location\" button below")
        default:
            print("Code = \(error.code)")
        }
        
        print(error.debugDescription)
    }
}

