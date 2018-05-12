// Copyright 2014-present Max von Webel. All Rights Reserved.

import Foundation

protocol MinuteChangeNotifierDelegate: class {
    func minuteDidChange(notifier: MinuteChangeNotifier)
}

class MinuteChangeNotifier {
    var timer: Timer!
    weak var delegate: MinuteChangeNotifierDelegate?

    static func nextMinute(fromDate date: Date) -> Date {
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.era, .year, .month, .day, .hour, .minute], from: date as Date)
        components.second = 0
        components.minute = components.minute! + 1
        return calendar.date(from: components)!
    }

    deinit {
        timer.invalidate()
    }

    init(delegate: MinuteChangeNotifierDelegate) {
        let date = MinuteChangeNotifier.nextMinute(fromDate: Date())
        timer = Timer(fireAt: date as Date, interval: 60.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        self.delegate = delegate
    }

    @objc func timerFired(timer: Timer) {
        self.delegate?.minuteDidChange(notifier: self)
    }
}
