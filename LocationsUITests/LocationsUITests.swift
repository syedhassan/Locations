//
//  LocationsUITests.swift
//  LocationsUITests
//
//  Created by Sana Hassan on 1/19/16.
//  Copyright © 2016 Home. All rights reserved.
//

import XCTest

class LocationsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testHappyPath() {
        
        checkForNameSorting()
        checkForDistanceSorting()
        checkForArrivalTimeSorting()
        
        XCUIApplication().tables.cells.elementBoundByIndex(0)
            .waitToExist()
            .tap()

        XCUIApplication().buttons["Close"].tap()
        
        XCUIApplication().buttons["actionButton"]
            .waitToExist()
            .tap()
    }
    
    func checkForNameSorting() {
        XCUIApplication().buttons["actionButton"]
            .waitToExist()
            .tap()
        
        XCUIApplication().buttons["Name"]
            .waitToExist()
            .tap()
        
        let firstTextView = XCUIApplication().tables.cells.elementBoundByIndex(0).descendantsMatchingType(.Any).elementMatchingType(.Any, identifier: "locationName").label
        let secondTextView = XCUIApplication().tables.cells.elementBoundByIndex(1).descendantsMatchingType(.Any).elementMatchingType(.Any, identifier: "locationName").label
        
        XCTAssert(firstTextView < secondTextView, "Locations are not sorted by name")
    }
    
    func checkForDistanceSorting() {
        XCUIApplication().buttons["actionButton"]
            .waitToExist()
            .tap()
        
        XCUIApplication().buttons["Distance"]
            .waitToExist()
            .tap()
        
        var firstDistance = XCUIApplication().tables.cells.elementBoundByIndex(0).descendantsMatchingType(XCUIElementType.Any).elementMatchingType(.Any, identifier: "locationDistance").label
        var secondDistance = XCUIApplication().tables.cells.elementBoundByIndex(1).descendantsMatchingType(XCUIElementType.Any).elementMatchingType(.Any, identifier: "locationDistance").label
        firstDistance = firstDistance.stringByReplacingOccurrencesOfString(" miles", withString: "")
        secondDistance = secondDistance.stringByReplacingOccurrencesOfString(" miles", withString: "")
        let fDouble = Double(firstDistance)
        let sDouble = Double(secondDistance)
        XCTAssert(fDouble < sDouble, "Locations are not sorted by distance")
    }
    
    func checkForArrivalTimeSorting() {
        XCUIApplication().buttons["actionButton"]
            .waitToExist()
            .tap()
        
        XCUIApplication().buttons["Arrival Time"]
            .waitToExist()
            .tap()
        
        let firstTime = XCUIApplication().tables.cells.elementBoundByIndex(0).descendantsMatchingType(XCUIElementType.Any).elementMatchingType(.Any, identifier: "locationTime").label
        let secondTime = XCUIApplication().tables.cells.elementBoundByIndex(1).descendantsMatchingType(XCUIElementType.Any).elementMatchingType(.Any, identifier: "locationTime").label
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy h:mm a"
        
        XCTAssert(dateFormatter.dateFromString(firstTime)?.compare(dateFormatter.dateFromString(secondTime)!) == .OrderedAscending, "Locations not sorted by time")
    }
    
}

extension XCUIElement {
    func waitToExist() -> XCUIElement {
        let doesElementExist: () -> Bool = {
            return self.exists
        }
        waitFor(doesElementExist, failureMessage: "Timed out waiting for element to exist.")
        return self
    }
    
    private func waitFor(expression: () -> Bool, failureMessage: String) {
        let startTime = NSDate.timeIntervalSinceReferenceDate()
        
        while (!expression()) {
            if (NSDate.timeIntervalSinceReferenceDate() - startTime > 30.0) {
                NSException(name: "Timeout", reason: failureMessage, userInfo: nil).raise()
            }
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, true)
        }
    }
}
