// Copyright 2014-present Max von Webel. All Rights Reserved.

import UIKit

extension NSAttributedString {
    func fullRange() -> NSRange {
        return NSMakeRange(0, self.length)
    }
}

extension Sequence where Iterator.Element == NSAttributedString {
    func joined(separator: NSAttributedString = NSAttributedString(string: "")) -> NSAttributedString {
        return self.reduce(NSMutableAttributedString()) { (result, element) -> NSMutableAttributedString in
            if result.length != 0 {
                result.append(separator)
            }
            result.append(element)
            return result
        }
    }
    
    func joined(separator: String) -> NSAttributedString {
        return self.joined(separator: NSMutableAttributedString(string: separator))
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
        
        timeLabel.attributedText = [locationString, timeString].joined(separator: "\n")
    }
}
