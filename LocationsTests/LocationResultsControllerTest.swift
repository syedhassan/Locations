//
//  LocationResultsControllerTest.swift
//  Locations
//
//  Created by Sana Hassan on 1/20/16.
//  Copyright © 2016 Home. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Locations

class LocationResultsControllerTest: XCTestCase {
    
    var viewController : LocationResultsController!
    
    class FakeLocationService : RequestService {
        var getLocationServiceWasCalled = false
        var result = [Location(locationID: 1234, locationName: "Name1", latitude: nil, longitude: nil, address: nil, arrivalTime: nil, distance: nil), Location(locationID: 5678, locationName: "Name2", latitude: nil, longitude: nil, address: nil, arrivalTime: nil, distance: nil)]
        
        override func requestLocations(userLocation: CLLocationCoordinate2D, onSuccess: RequestResponse, onFailure: RequestFailure) {
            getLocationServiceWasCalled = true
            onSuccess(result: result)
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = LocationResultsController()
    }
    
    func testFetchLocations() {
        let fakeRequestService = FakeLocationService()
        viewController.getLocations(fakeRequestService)
        XCTAssertTrue(fakeRequestService.getLocationServiceWasCalled)
        XCTAssertEqual(fakeRequestService.result, viewController.items)
    }
    
    
}
