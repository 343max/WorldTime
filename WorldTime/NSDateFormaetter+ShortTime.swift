//
//  NSDateFormaetter+ShortDate.swift
//  WorldTime
//
//  Created by Max von Webel on 20.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    static func shortTime() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }
}