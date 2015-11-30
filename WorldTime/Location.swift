//
//  Location.swift
//  WorldTime
//
//  Created by Max von Webel on 24.09.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import Foundation

struct Location {
    var name: String
    var timeZone: NSTimeZone

    init(name: String, timeZone: NSTimeZone) {
        self.name = name
        self.timeZone = timeZone;
    }

    init(name: String, timeZoneAbbrevation: String) {
        guard let timeZone = NSTimeZone(abbreviation: timeZoneAbbrevation) else {
            fatalError("couldn't create timeZone: \(timeZoneAbbrevation)")
        }
        self.init(name: name, timeZone: timeZone)
    }

    init(name: String, timeZoneName: String) {
        guard let timeZone = NSTimeZone(name: timeZoneName) else {
            fatalError("couldn't create timeZone: \(timeZoneName)")
        }
        self.init(name: name, timeZone: timeZone)
    }
}

extension Location {
    typealias Dictionary = [String: AnyObject]
    static var nameKey = "Name"
    static var timeZoneNameKey = "TimeZoneName"

    init?(dictionary: Location.Dictionary) {
        guard let name = dictionary[Location.nameKey] as? String,
              let timeZoneName = dictionary[Location.timeZoneNameKey] as? String else {
            return nil
        }
        self.init(name: name, timeZoneName: timeZoneName)
    }

    var dictionary: Location.Dictionary {
        get {
            return [
                Location.nameKey: self.name,
                Location.timeZoneNameKey: self.timeZone.name
            ]
        }
    }

    static func from(arrayOfDicts arrayOfDicts: [Location.Dictionary]) -> [Location] {
        return arrayOfDicts.flatMap() { (dict) -> Location? in
            return Location(dictionary: dict)
        }
    }

    static func arrayOfDicts(locations: [Location]) -> [Location.Dictionary] {
        return locations.map() { (location) -> Location.Dictionary in
            return location.dictionary
        }
    }
}

extension Location {
    func stringFromDate(date: NSDate, formatter: NSDateFormatter) -> String {
        formatter.timeZone = timeZone
        return formatter.stringFromDate(date)
    }
}

extension Location {
    static var locationsKey = "Locations"
    static var userDefaults = NSUserDefaults(suiteName: "group.de.343max.WorldTime")!

    static func defaultLocations() -> [Location] {
        return [
            Location(name: "San Francisco", timeZoneAbbrevation: "PST"),
            Location(name: "Berlin", timeZoneAbbrevation: "CEST")
        ]
    }

    static func fromDefaults() -> [Location] {
        guard let locations = Location.userDefaults.arrayForKey(locationsKey) as? [Location.Dictionary] else {
            return self.defaultLocations()
        }

        return self.from(arrayOfDicts: locations)
    }

    static func toDefaults(locations: [Location]) {
        self.userDefaults.setValue(self.arrayOfDicts(locations), forKey: self.locationsKey)
        self.userDefaults.synchronize()
    }
}