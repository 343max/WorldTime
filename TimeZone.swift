// Copyright 2014-present Max von Webel. All Rights Reserved.

import Foundation

func relativeHours(seconds: Int, shortStyle: Bool = true) -> String? {
    guard seconds != 0 || !shortStyle else {
        return nil
    }
    
    let hours = seconds / 3600
    let minutes = abs(hours * 60 - seconds / 60)
    let minutesString: String = {
        if minutes == 0 && shortStyle {
            return ""
        } else if minutes == 15 && shortStyle {
            return "¼"
        } else if minutes == 30 && shortStyle {
            return "½"
        } else if minutes == 45 && shortStyle {
            return "¾"
        } else {
            return String(format: ":%02d", minutes)
        }
    }()
    
    let prefix = seconds > 0 ? "+" : (seconds < 0 ? "-" : "±")
    return "\(prefix)\(abs(hours))\(minutesString)"
}

extension TimeZone {
    func seconds(from timeZone: TimeZone, for date: Date) -> Int {
        let selfSeconds = self.secondsFromGMT(for: date)
        let otherSeconds = timeZone.secondsFromGMT(for: date)
        return otherSeconds - selfSeconds
    }
    
    var GMTdiff: String {
        get {
            return "GMT \(relativeHours(seconds: self.secondsFromGMT(), shortStyle: false)!)"
        }
    }
}
