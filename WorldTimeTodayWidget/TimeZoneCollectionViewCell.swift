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
    static let timeFormatter = DateFormatter.shortTime()

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
        self.backgroundColor = UIColor.clear
        super.awakeFromNib()
    }
    
    func updateTime() {
        let timeString = NSMutableAttributedString(string: location.stringFrom(date: Date(), formatter: TimeZoneCollectionViewCell.timeFormatter))
        let locationString = NSMutableAttributedString(string: location.name)
        
        if (timeHidden) {
            timeString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.clear, range: timeString.fullRange())
        }
        timeString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 24.0), range: timeString.fullRange())
        locationString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14.0), range: locationString.fullRange())
        
        timeLabel.attributedText = [locationString, timeString].reduce(NSMutableAttributedString()) { (concatenatedString, line) -> NSMutableAttributedString in
            if concatenatedString.length != 0 {
                concatenatedString.append(NSAttributedString(string: "\n"))
            }
            concatenatedString.append(line)
            return concatenatedString
        }
    }
}
