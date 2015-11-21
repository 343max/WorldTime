//
//  LocationsDataSource.swift
//  WorldTime
//
//  Created by Max von Webel on 24.09.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

class LocationsDataSource: NSObject {
    static let reuseIdentifier = "TimeZoneCollectionViewCell"

    var timeHidden = false
    var textColor = UIColor.whiteColor()
    var locations: [Location] = []
}
