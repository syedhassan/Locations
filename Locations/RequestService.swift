//
//  RequestService.swift
//  Locations
//
//  Created by Sana Hassan on 1/20/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreLocation

typealias RequestResponse = (result : [Location]) -> Void
typealias RequestFailure = (error: NSError) -> Void

class RequestService: NSObject {
    
    func requestLocations(userLocation:CLLocationCoordinate2D, onSuccess: RequestResponse, onFailure: RequestFailure) {
        let request = NSURLRequest(URL: NSURL(string: "http://localsearch.azurewebsites.net/api/Locations")!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let dataTaskCompletionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void = { data, _, error in
            guard let data = data, responseJSON = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? [AnyObject] else {
                onFailure(error: error!)
                return
            }
            
            let items = self.parseResponseJSON(userLocation, responseJSON: responseJSON)
            onSuccess(result: items)
        }
        
        let task = session.dataTaskWithRequest(request, completionHandler: dataTaskCompletionHandler)
        task.resume()
    }
    
    func parseResponseJSON(userLocation: CLLocationCoordinate2D, responseJSON: [AnyObject]) -> [Location] {
        var items = [Location]()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        for location in responseJSON {
            if let location = location as? [String : AnyObject] {
                let storeLocation = CLLocation(latitude: location["Latitude"] as! Double, longitude: location["Longitude"] as! Double)
                let userLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                
                items.append(Location(locationID: location["ID"] as? Int,
                    locationName: location["Name"] as? String,
                    latitude: location["Latitude"] as? Double,
                    longitude: location["Longitude"] as? Double,
                    address: location["Address"] as? String,
                    arrivalTime: dateFormatter.dateFromString(location["ArrivalTime"] as! String),
                    distance: storeLocation.distanceFromLocation(userLocation)))
            }
        }
        return items
    }
    
}
