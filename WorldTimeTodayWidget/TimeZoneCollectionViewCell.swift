//
//  TimeZoneCollectionViewCell.swift
//  WorldTime
//
//  Created by Max von Webel on 21/09/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

import UIKit

class TimeZoneCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    
    var timeZone: TimeZone? {
        didSet(newTimezone) {
            if let timeZone = newTimezone {
                timeLabel.text = timeZone.locationName
            } else {
                timeLabel.text = nil
            }
        }
    }

    override func awakeFromNib() {
        self.backgroundColor = UIColor.orangeColor()
        super.awakeFromNib()
    }

}
