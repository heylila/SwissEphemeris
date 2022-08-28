//
//  MoonPhases.swift
//  
//
//  Created by Sam Krishna on 8/27/22.
//

import XCTest
@testable import SwissEphemeris

class MoonPhases: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    // 8 Lunar Phases (in relationship to the Sun)
    // 1: New Moon = 0 degrees
    // 2: Waxing Crescent = 45 degrees
    // 3: First Quarter = 90 degrees
    // 4: Waxing Gibbous = 135 degrees
    // 5: Full Moon = 180 degrees
    // 6: Waning Gibbous = 225 degrees
    // 7: Third Quarter = 270 degrees
    // 8: Waning Crescent = 315 degrees

    func testFindNextNewMoon() throws {
        let originDate = Date(fromString: "2022-08-27 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(.day, value: 29)!

        let interval = TimeSlice.hour.slice
        var sunPositions = BodiesRequest(body: Planet.sun).fetch(start: originDate, end: endDate, interval: interval)
        var moonPositions = BodiesRequest(body: Planet.moon).fetch(start: originDate, end: endDate, interval: interval)

        XCTAssert(sunPositions.count == moonPositions.count)

        var sun2Moon: [(sun: Coordinate<Planet>, moon: Coordinate<Planet>)] = Array(zip(sunPositions, moonPositions))
        var minPos = sun2Moon.min { lhs, rhs in
            return lhs.sun.longitudeDelta(other: lhs.moon) < rhs.sun.longitudeDelta(other: rhs.moon)
        }

        let minPosDate = minPos!.sun.date
        let newMoonTestStart = minPosDate.offset(.minute, value: -60)!
        let newMoonTestEnd = minPosDate.offset(.minute, value: 60)!
        sunPositions = BodiesRequest(body: Planet.sun).fetch(start: newMoonTestStart, end: newMoonTestEnd, interval: TimeSlice.minute.slice)
        moonPositions = BodiesRequest(body: Planet.moon).fetch(start: newMoonTestStart, end: newMoonTestEnd, interval: TimeSlice.minute.slice)

        sun2Moon = Array(zip(sunPositions, moonPositions))

        minPos = sun2Moon.min { lhs, rhs in

            return lhs.sun.longitudeDelta(other: lhs.moon) < rhs.sun.longitudeDelta(other: rhs.moon)
        }
        let minPosDateString = minPos!.sun.date.toString(format: .cocoaDateTime)!
        print("new moon at \(minPosDateString)")
    }

    func testFindNextFullMoon() throws {
        let originDate = Date(fromString: "2022-08-27 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(.day, value: 29)!

        let interval = TimeSlice.hour.slice
        var sunPositions = BodiesRequest(body: Planet.sun).fetch(start: originDate, end: endDate, interval: interval)
        var moonPositions = BodiesRequest(body: Planet.moon).fetch(start: originDate, end: endDate, interval: interval)

        XCTAssert(sunPositions.count == moonPositions.count)

        var sun2Moon: [(sun: Coordinate<Planet>, moon: Coordinate<Planet>)] = Array(zip(sunPositions, moonPositions))
        var minPos = sun2Moon.min { lhs, rhs in
            return (180.0 - lhs.sun.longitudeDelta(other: lhs.moon)) < (180.0 - rhs.sun.longitudeDelta(other: rhs.moon))
        }

        let minPosDate = minPos!.sun.date
        let fullMoonTestStart = minPosDate.offset(.day, value: -1)!
        let fullMoonTestEnd = minPosDate.offset(.day, value: 1)!
        sunPositions = BodiesRequest(body: Planet.sun).fetch(start: fullMoonTestStart, end: fullMoonTestEnd, interval: TimeSlice.minute.slice)
        moonPositions = BodiesRequest(body: Planet.moon).fetch(start: fullMoonTestStart, end: fullMoonTestEnd, interval: TimeSlice.minute.slice)

        sun2Moon = Array(zip(sunPositions, moonPositions))
        minPos = sun2Moon.min { lhs, rhs in
            return abs(180.0 - lhs.sun.longitudeDelta(other: lhs.moon)) < abs(180.0 - rhs.sun.longitudeDelta(other: rhs.moon))
        }

        guard let minPos = minPos else {
            XCTFail("We couldn't create a min position")
            return
        }

        let minPosDateString = minPos.sun.date.toString(format: .cocoaDateTime)!
        print("full moon at \(minPosDateString)")
        print("sun longitude = \(minPos.sun.longitude)")
        print("moon longitude = \(minPos.moon.longitude)")
    }

}
