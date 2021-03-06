// Copyright 2014-present Max von Webel. All Rights Reserved.

import Foundation

struct Location {
    var name: String
    var timeZone: TimeZone

    init(name: String, timeZone: TimeZone) {
        self.name = name
        self.timeZone = timeZone;
    }

    init(name: String, timeZoneAbbrevation: String) {
        guard let timeZone = TimeZone(abbreviation: timeZoneAbbrevation) else {
            fatalError("couldn't create timeZone: \(timeZoneAbbrevation)")
        }
        self.init(name: name, timeZone: timeZone)
    }

    init(name: String, timeZoneName: String) {
        guard let timeZone = TimeZone(identifier: timeZoneName) else {
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
                Location.nameKey: self.name as AnyObject,
                Location.timeZoneNameKey: self.timeZone.identifier as AnyObject
            ]
        }
    }

    static func from(arrayOfDicts: [Location.Dictionary]) -> [Location] {
        return arrayOfDicts.compactMap() { (dict) -> Location? in
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
    func stringFrom(date: Date, formatter: DateFormatter) -> String {
        formatter.timeZone = timeZone
        return formatter.string(from: date as Date)
    }
}

extension Location {
    static var locationsKey = "Locations"
    static var userDefaults = UserDefaults(suiteName: "group.de.343max.WorldTime")!

    static func defaultLocations() -> [Location] {
        return [
            Location(name: "San Francisco", timeZoneAbbrevation: "PST"),
            Location(name: "Berlin", timeZoneAbbrevation: "CEST")
        ]
    }

    static func fromDefaults() -> [Location] {
        guard let locations = Location.userDefaults.array(forKey: locationsKey) as? [Location.Dictionary] else {
            return self.defaultLocations()
        }

        return self.from(arrayOfDicts: locations)
    }

    static func toDefaults(locations: [Location]) {
        self.userDefaults.setValue(self.arrayOfDicts(locations: locations), forKey: self.locationsKey)
        self.userDefaults.synchronize()
    }
}
