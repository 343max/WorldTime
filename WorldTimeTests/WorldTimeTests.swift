// Copyright 2014-present Max von Webel. All Rights Reserved.

import XCTest

@testable import WorldTime

class WorldTimeTests: XCTestCase {
    func testRelativeHoursAuckland() {
        XCTAssertEqual(relativeHours(seconds: 68400, shortStyle: false), "+19:00")
        XCTAssertEqual(relativeHours(seconds: 68400), "+19")
    }

    func testRelativeHoursBerlin() {
        XCTAssertEqual(relativeHours(seconds: 32400, shortStyle: false), "+9:00")
        XCTAssertEqual(relativeHours(seconds: 32400), "+9")
    }

    func testRelativeHoursSanFrancisco() {
        XCTAssertEqual(relativeHours(seconds: 0, shortStyle: false), "±0:00")
        XCTAssertNil(relativeHours(seconds: 0))
    }
    
    func testRelativeHoursHonolulu() {
        XCTAssertEqual(relativeHours(seconds: -10800, shortStyle: false), "-3:00")
        XCTAssertEqual(relativeHours(seconds: -10800), "-3")
    }

    func testRelativeHoursColombo() {
        XCTAssertEqual(relativeHours(seconds: 45000, shortStyle: false), "+12:30")
        XCTAssertEqual(relativeHours(seconds: 45000), "+12½")
    }

    func testRelativeHoursEuclka() {
        XCTAssertEqual(relativeHours(seconds: 56700, shortStyle: false), "+15:45")
        XCTAssertEqual(relativeHours(seconds: 56700), "+15¾")
    }

}
