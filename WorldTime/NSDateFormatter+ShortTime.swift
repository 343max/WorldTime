// Copyright 2014-present Max von Webel. All Rights Reserved.

import Foundation

extension DateFormatter {
    static func shortTime() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
}
