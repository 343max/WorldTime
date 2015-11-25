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
    static let preferedHeight: CGFloat = 50.0
    static let timeFormatter = NSDateFormatter.shortTime()

    static func preferredItemSize(collectionViewWidth viewWidth: CGFloat, itemCount: Int) -> CGSize {
        return CGSize(width: viewWidth / CGFloat(itemCount),
                      height: TimeZoneCollectionViewCell.preferedHeight)
    }

    @IBOutlet weak var timeLabel: UILabel!

    var location: Location! {
        didSet(oldLocation) {
            updateTime()
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
    
    func updateTime() {
        let timeString = NSMutableAttributedString(string: location.stringFromDate(NSDate(), formatter: TimeZoneCollectionViewCell.timeFormatter))
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
