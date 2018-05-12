//
//  NSDateFormaetter+ShortDate.swift
//  WorldTime
//
//  Created by Max von Webel on 20.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import Foundation

extension DateFormatter {
    static func shortTime() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
}
