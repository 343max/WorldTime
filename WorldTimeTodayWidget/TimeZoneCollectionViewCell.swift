//
//  TimeZoneCollectionViewCell.swift
//  WorldTime
//
//  Created by Max von Webel on 21/09/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func fullRange() -> NSRange {
        return NSMakeRange(0, self.length)
    }
}

class TimeZoneCollectionViewCell: UICollectionViewCell {
    static let timeFormatter: NSDateFormatter = with(NSDateFormatter()) { timeFormatter in
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
    }

    @IBOutlet weak var timeLabel: UILabel!
    private var timer: NSTimer?
    
    var location: Location! {
        didSet(oldLocation) {
            updateTime()
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        }
    }
    
    var timeHidden: Bool = false {
        didSet(oldTimeHidden) {
            updateTime()
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
        TimeZoneCollectionViewCell.timeFormatter.timeZone = location.timeZone
        
        let timeString = NSMutableAttributedString(string: TimeZoneCollectionViewCell.timeFormatter.stringFromDate(NSDate()))
        let locationString = NSMutableAttributedString(string: location.name)
        
        if (timeHidden) {
            timeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.clearColor(), range: timeString.fullRange())
        }
        timeString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(24.0), range: timeString.fullRange())
        locationString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14.0), range: locationString.fullRange())
        
        timeString.appendAttributedString(NSAttributedString(string: "\n"))
        timeString.appendAttributedString(locationString)
        
        timeLabel.attributedText = timeString
    }
}
