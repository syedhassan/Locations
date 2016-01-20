//
//  CustomTableViewCell.swift
//  Locations
//
//  Created by Sana Hassan on 1/19/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    var didUpdateConstraints = false
    
    init(locationData : Location) {
        super.init(style:  .Default, reuseIdentifier: NSStringFromClass(self.dynamicType))
        updateConstraints()
        backgroundColor = .clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateWithLocation(location : Location) {
        self.locationName.text = location.locationName
//        self.distanceFromCurrentLocation.text =
    }
    
    private lazy var locationName : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 16)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    
    private lazy var distanceFromCurrentLocation : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 13)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    
    private lazy var arrivalTime : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 13)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    

}
