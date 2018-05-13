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
    static let preferedHeight: CGFloat = 55 // maxiumum widget height: 110px
    static let timeFormatter = DateFormatter.shortTime()
    static let dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE", options: 0, locale: Locale.current)
        return formatter
    }()

    @IBOutlet weak var timeLabel: UILabel!
    
    var location: Location! {
        didSet(oldLocation) {
            update()
        }
    }
    
    var referenceTimeZone: TimeZone = TimeZone.autoupdatingCurrent {
        didSet {
            update()
        }
    }
    
    var timeHidden: Bool = false {
        didSet(oldTimeHidden) {
            update()
        }
    }
    
    var dayOfWeek: String? {
        get {
            let date = Date()
            let formatter = TimeZoneCollectionViewCell.dayOfWeekFormatter
            formatter.timeZone = referenceTimeZone
            let localWeekday = formatter.string(from: date)
            formatter.timeZone = location.timeZone
            let weekday = formatter.string(from: date)
            
            return weekday == localWeekday ? nil : weekday
        }
    }

    func update() {
        func attributes(fontSize: CGFloat, hidden: Bool = false, color: UIColor? = nil) -> [NSAttributedStringKey : Any] {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.85
            var attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize),
                                                             NSAttributedStringKey.paragraphStyle: paragraphStyle]
            if hidden || color != nil {
                attributes[NSAttributedStringKey.foregroundColor] = color ?? UIColor.clear
            }
            return attributes
        }
        
        let locationString = [NSAttributedString(string: location.name, attributes: attributes(fontSize: 11.0)),
                              NSAttributedString(string: relativeHours(seconds: referenceTimeZone.seconds(from: location.timeZone, for: Date())) ?? "", attributes: attributes(fontSize: 11.0, hidden: false, color: UIColor(white: 0.0, alpha: 0.4)))].joined(separator: " ")
        let timeString = NSAttributedString(string: location.stringFrom(date: Date(), formatter: TimeZoneCollectionViewCell.timeFormatter), attributes: attributes(fontSize: 22.0, hidden: timeHidden))
        let weekdayString = NSAttributedString(string: dayOfWeek ?? " ", attributes: attributes(fontSize: 11.0, hidden: timeHidden))

        timeLabel.attributedText = [locationString, timeString, weekdayString].joined(separator: "\n")
    }
}
