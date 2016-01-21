//
//  RequestServiceTest.swift
//  Locations
//
//  Created by Sana Hassan on 1/20/16.
//  Copyright © 2016 Home. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Locations

class RequestServiceTest: XCTestCase {
    
    var requestService : RequestService!
    override func setUp() {
        super.setUp()
        requestService = RequestService()
    }
    
    func testJSONParser() {
        let userLocation = CLLocationCoordinate2DMake(41.870083, -87.657992)
        let locations = requestService.parseResponseJSON(userLocation, responseJSON: loadDictionaryForJSONFile("locations")!)
        XCTAssertEqual(locations.count, 11)
        XCTAssertEqual(locations[0].locationID!, 3778)
        XCTAssertEqual(locations[0].locationName!, "Doughnut Vault Canal")
        XCTAssertEqual(locations[0].latitude!, 41.883976)
        XCTAssertEqual(locations[0].longitude!, -87.639346)
        XCTAssertEqual(locations[0].address, "11 N Canal St L30 Chicago, IL 60606")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        XCTAssertEqual(locations[0].arrivalTime, dateFormatter.dateFromString("2016-01-21T03:13:03.817"))
        XCTAssertEqual(String(format: "%.2f", locations[0].distance!), "2185.45")
    }
    
}

extension XCTestCase {
    
    func loadDictionaryForJSONFile(path: String) -> [AnyObject]? {
        
        guard let filePath = NSBundle(forClass: self.dynamicType).pathForResource(path, ofType: "json") else {
            return nil
        }
        
        let data = NSData(contentsOfFile:filePath)
        guard let resultJSON = try! NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers, NSJSONReadingOptions.MutableLeaves]) as? [AnyObject] else {
            return nil
        }
        
        return resultJSON
    }
    
}
