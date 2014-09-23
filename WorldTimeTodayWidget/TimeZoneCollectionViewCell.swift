//
//  TimeZoneCollectionViewCell.swift
//  WorldTime
//
//  Created by Max von Webel on 21/09/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

import UIKit

var timeFormatter = with(NSDateFormatter()) { timeFormatter in
    timeFormatter.dateStyle = .NoStyle
    timeFormatter.timeStyle = .ShortStyle
}

class TimeZoneCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    
    var timeZone: TimeZone! {
        didSet(oldTimezone) {
            updateTime()
        }
    }

    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
        super.awakeFromNib()
    }

    func updateTime() {
        timeFormatter.timeZone = timeZone.timeZone
        timeLabel.text = timeFormatter.stringFromDate(NSDate())
    }
}
