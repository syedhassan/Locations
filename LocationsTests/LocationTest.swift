//
//  LocationTest.swift
//  Locations
//
//  Created by Sana Hassan on 1/20/16.
//  Copyright © 2016 Home. All rights reserved.
//

import XCTest

@testable import Locations

class LocationTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStruct() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let date = NSDate()
        let location = Location(locationID: 1234, locationName: "fakeName", latitude: 123.43, longitude: -98.123, address: "1 Main Dr", arrivalTime: date, distance: 12.3)
        XCTAssertEqual(location.locationID, 1234)
        XCTAssertEqual(location.locationName, "fakeName")
        XCTAssertEqual(location.latitude, 123.43)
        XCTAssertEqual(location.longitude, -98.123)
        XCTAssertEqual(location.address, "1 Main Dr")
        XCTAssertEqual(location.arrivalTime, date)
        XCTAssertEqual(location.distance, 12.3)
    }
    
    func testMutatingFunc() {
        var location = Location(locationID: 1234, locationName: "fakeName", latitude: 123.43, longitude: -98.123, address: "1 Main Dr", arrivalTime: nil, distance: 12.3)
        XCTAssertEqual(location.distance, 12.3)
        location.updateDistance(153.12)
        XCTAssertEqual(location.distance, 153.12)
    }
    
}
