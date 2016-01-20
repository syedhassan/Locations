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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        backgroundColor = .clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            let views = ["locationName" : self.locationName, "distanceLabel" : self.distanceFromCurrentLocation, "arrivalTime" : self.arrivalTime]
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[locationName]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[distanceLabel]->=5-[arrivalTime]-5-|", options: NSLayoutFormatOptions.AlignAllTop, metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[locationName]-10-[distanceLabel]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        }
        super.updateConstraints()
    }
    
    func updateWithLocation(location : Location) {
        self.locationName.text = location.locationName
        if let distance = location.distance {
            self.distanceFromCurrentLocation.text = String(format: "%.2f miles", distance*0.000621371)
        }
        if let time = location.arrivalTime {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyy h:mm a"
            self.arrivalTime.text = dateFormatter.stringFromDate(time)
        }
        updateConstraints()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private lazy var locationName : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 16)
        label.textAlignment = NSTextAlignment.Left
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    
    private lazy var distanceFromCurrentLocation : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    
    private lazy var arrivalTime : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 12)
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
}
