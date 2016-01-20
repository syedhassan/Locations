//
//  Location.swift
//  Locations
//
//  Created by Sana Hassan on 1/19/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

struct Location {
    let locationID: String?
    let locationName: String?
    let latitude: Double?
    let longitude: Double?
    let address: String?
    let arrivalTime: NSDate?
    var distance: Double?
    
    mutating func updateDistance(value: Double) {
        distance = value
    }
}

