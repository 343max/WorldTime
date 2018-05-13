// Copyright 2014-present Max von Webel. All Rights Reserved.

import XCTest

@testable import WorldTime

class WorldTimeTests: XCTestCase {
    func testRelativeHoursAuckland() {
        XCTAssertEqual(relativeHours(seconds: 68400), "+19:00")
    }

    func testRelativeHoursBerlin() {
        XCTAssertEqual(relativeHours(seconds: 32400), "+9:00")
    }

    func testRelativeHoursSanFrancisco() {
        XCTAssertEqual(relativeHours(seconds: 0), "±0:00")
    }
    
    func testRelativeHoursHonolulu() {
        XCTAssertEqual(relativeHours(seconds: -10800), "-3:00")
    }

    func testRelativeHoursColombo() {
        XCTAssertEqual(relativeHours(seconds: 45000), "+12:30")
    }

    func testRelativeHoursEuclka() {
        XCTAssertEqual(relativeHours(seconds: 56700), "+15:45")
    }

}
