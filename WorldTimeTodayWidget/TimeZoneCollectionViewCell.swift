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

extension NSAttributedString {
    func fullRange() -> NSRange {
        return NSMakeRange(0, self.length)
    }
}

class TimeZoneCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    private var timer: NSTimer?
    
    var timeZone: TimeZone! {
        didSet(oldTimezone) {
            updateTime()
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        }
    }

    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
    }

    @objc func updateTime() {
        timeFormatter.timeZone = timeZone.timeZone
        timeLabel.text = timeFormatter.stringFromDate(NSDate())
        
        let timeString = NSMutableAttributedString(string: timeFormatter.stringFromDate(NSDate()))
        let locationString = NSMutableAttributedString(string: timeZone.locationName)
        
        let fontName = "HelveticaNeue-Light"
        
        timeString.addAttribute(NSFontAttributeName, value: UIFont(name: fontName, size: 24.0), range: timeString.fullRange())
        locationString.addAttribute(NSFontAttributeName, value: UIFont(name: fontName, size: 14.0), range: locationString.fullRange())
        
        timeString.appendAttributedString(NSAttributedString(string: "\n"))
        timeString.appendAttributedString(locationString)
        
        timeLabel.attributedText = timeString
    }
}
