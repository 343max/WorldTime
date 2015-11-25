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
    var timer: NSTimer!
    weak var delegate: MinuteChangeNotifierDelegate?

    static func nextMinute(fromDate date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Era, .Year, .Month, .Day, .Hour, .Minute], fromDate: date)
        components.second = 0
        components.minute += 1
        return calendar.dateFromComponents(components)!
    }

    deinit {
        timer.invalidate()
    }

    init(delegate: MinuteChangeNotifierDelegate) {
        let date = MinuteChangeNotifier.nextMinute(fromDate: NSDate())
        timer = NSTimer(fireDate: date, interval: 60.0, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        self.delegate = delegate
    }

    @objc func timerFired(timer: NSTimer) {
        self.delegate?.minuteDidChange(self)
    }
}