//
//  MinuteChangeNotification.swift
//  WorldTime
//
//  Created by Max von Webel on 24.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import Foundation

protocol MinuteChangeNotifierDelegate: class {
    func minuteDidChange(notifier: MinuteChangeNotifier)
}

class MinuteChangeNotifier {
    var timer: Timer!
    weak var delegate: MinuteChangeNotifierDelegate?

    static func nextMinute(fromDate date: NSDate) -> NSDate {
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.era, .year, .month, .day, .hour, .minute], from: date as Date)
        components.second = 0
        components.minute = components.minute! + 1
        return calendar.date(from: components) as NSDate!
    }

    deinit {
        timer.invalidate()
    }

    init(delegate: MinuteChangeNotifierDelegate) {
        let date = MinuteChangeNotifier.nextMinute(fromDate: NSDate())
        timer = Timer(fireAt: date as Date, interval: 60.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        self.delegate = delegate
    }

    @objc func timerFired(timer: Timer) {
        self.delegate?.minuteDidChange(notifier: self)
    }
}
