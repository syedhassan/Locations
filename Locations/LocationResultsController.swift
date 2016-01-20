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
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("showActionSheet"))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        fetchLocationData()
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let loc = self.items[indexPath.row]
        cell.textLabel?.text = loc.locationName!
        
        cell.layoutMargins = UIEdgeInsetsZero
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
    
    func fetchLocationData() {
        let request = NSURLRequest(URL: NSURL(string: "http://localsearch.azurewebsites.net/api/Locations")!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request, completionHandler: dataTaskCompletionHandler)
        task.resume()
    }
    
    func dataTaskCompletionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        guard let responseJSON = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? [AnyObject] else {
            print("Code = \(error?.code) and Info = \(error?.userInfo)")
            return
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        for location in responseJSON {
            if let location = location as? [String : AnyObject] {
                let storeLocation = CLLocation(latitude: location["Latitude"] as! Double, longitude: location["Longitude"] as! Double)
                let userLocation = CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                
                items.append(Location(locationID: location["ID"] as? String,
                                      locationName: location["Name"] as? String,
                                      latitude: location["Latitude"] as? Double,
                                      longitude: location["Longitude"] as? Double,
                                      address: location["Address"] as? String,
                                      arrivalTime: dateFormatter.dateFromString(location["ArrivalTime"] as! String),
                                      distance: storeLocation.distanceFromLocation(userLocation)))
            }
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
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

