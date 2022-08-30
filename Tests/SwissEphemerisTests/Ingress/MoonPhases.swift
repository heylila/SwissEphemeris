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
        var newMoonPos = sun2Moon.min { lhs, rhs in
            return lhs.sun.longitudeDelta(other: lhs.moon) < rhs.sun.longitudeDelta(other: rhs.moon)
        }

        let minPosDate = newMoonPos!.sun.date
        let newMoonTestStart = minPosDate.offset(.minute, value: -60)!
        let newMoonTestEnd = minPosDate.offset(.minute, value: 60)!
        sunPositions = BodiesRequest(body: Planet.sun).fetch(start: newMoonTestStart, end: newMoonTestEnd, interval: TimeSlice.minute.slice)
        moonPositions = BodiesRequest(body: Planet.moon).fetch(start: newMoonTestStart, end: newMoonTestEnd, interval: TimeSlice.minute.slice)

        sun2Moon = Array(zip(sunPositions, moonPositions))
        newMoonPos = sun2Moon.min { lhs, rhs in
            return lhs.sun.longitudeDelta(other: lhs.moon) < rhs.sun.longitudeDelta(other: rhs.moon)
        }

        let testDate = Date(fromString: "2022-09-25 14:55:00 -0700")
        XCTAssert(newMoonPos!.sun.date == testDate)
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
            return abs(180.0 - lhs.sun.longitudeDelta(other: lhs.moon)) < abs(180.0 - rhs.sun.longitudeDelta(other: rhs.moon))
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

        let testDate = Date(fromString: "2022-09-10 02:59:00 -0700")
        XCTAssert(minPos.sun.date == testDate)
    }

//    public func time(of phase: MoonPhase, forward: Bool = true, mean: Bool = true) -> JulianDay {
//        var k = floor(KPCAAMoonPhases_K(self.julianDay.date.fractionalYear))
//        switch phase {
//        case .newMoon:
//            k = k + 0.0
//        case .waxingCrescent:
//            k = k + 0.125
//        case .firstQuarter:
//            k = k + 0.25
//        case .waxingGibbous:
//            k = k + 0.375
//        case .fullMoon:
//            k = k + 0.50
//        case .waningGibbous:
//            k = k + 0.675
//        case .lastQuarter:
//            k = k + 0.75
//        case .waningCrescent:
//            k = k + 0.875
//        }

    func testFindNextTwoNewMoons() throws {
        let originDate = Date(fromString: "2022-08-22 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate1 = originDate.offset(.day, value: 29)!
        let hourSlice = TimeSlice.hour.slice
        var sunPositions = BodiesRequest(body: Planet.sun).fetch(start: originDate, end: endDate1, interval: hourSlice)
        var moonPositions = BodiesRequest(body: Planet.moon).fetch(start: originDate, end: endDate1, interval: hourSlice)

        XCTAssert(sunPositions.count == moonPositions.count)

        var sun2Moon: [(sun: Coordinate<Planet>, moon: Coordinate<Planet>)] = Array(zip(sunPositions, moonPositions))
        var newMoonPos = sun2Moon.min { lhs, rhs in
            return lhs.sun.longitudeDelta(other: lhs.moon) < rhs.sun.longitudeDelta(other: rhs.moon)
        }

        let minPosDate = newMoonPos!.sun.date
        let newMoonTestStart = minPosDate.offset(.minute, value: -60)!
        let newMoonTestEnd = minPosDate.offset(.minute, value: 60)!
        let minSlice = TimeSlice.minute.slice
        sunPositions = BodiesRequest(body: Planet.sun).fetch(start: newMoonTestStart, end: newMoonTestEnd, interval: minSlice)
        moonPositions = BodiesRequest(body: Planet.moon).fetch(start: newMoonTestStart, end: newMoonTestEnd, interval: minSlice)

        sun2Moon = Array(zip(sunPositions, moonPositions))
        newMoonPos = sun2Moon.min { lhs, rhs in
            return lhs.sun.longitudeDelta(other: lhs.moon) < rhs.sun.longitudeDelta(other: rhs.moon)
        }

        let testDate1 = Date(fromString: "2022-08-27 01:17:00 -0700")!
        XCTAssert(newMoonPos!.moon.date == testDate1, "moon date = \(newMoonPos!.moon.date.toString(format: .cocoaDateTime)!) and testDate1 = \(testDate1.toString(format: .cocoaDateTime)!)")

        let originDate2 = newMoonPos!.moon.date.offset(.day, value: 1)!
        let endDate2 = originDate2.offset(.day, value: 29)!
        sunPositions = BodiesRequest(body: Planet.sun).fetch(start: originDate2, end: endDate2, interval: hourSlice)
        moonPositions = BodiesRequest(body: Planet.moon).fetch(start: originDate2, end: endDate2, interval: hourSlice)

        sun2Moon = Array(zip(sunPositions, moonPositions))
        newMoonPos = sun2Moon.min { (lhs, rhs) in
            return lhs.sun.longitudeDelta(other: lhs.moon) < rhs.sun.longitudeDelta(other: rhs.moon)
        }
        let newMoonStart2 = newMoonPos!.moon.date.offset(.minute, value: -60)!
        let newMoonEnd2 = newMoonPos!.moon.date.offset(.minute, value: 60)!
        sunPositions = BodiesRequest(body: Planet.sun).fetch(start: newMoonStart2, end: newMoonEnd2, interval: minSlice)
        moonPositions = BodiesRequest(body: Planet.moon).fetch(start: newMoonStart2, end: newMoonEnd2, interval: minSlice)
        sun2Moon = Array(zip(sunPositions, moonPositions))
        newMoonPos = sun2Moon.min { lhs, rhs in
            return lhs.sun.longitudeDelta(other: lhs.moon) < rhs.sun.longitudeDelta(other: rhs.moon)
        }

        let testDate2 = Date(fromString: "2022-09-25 14:55:00 -0700")!
        XCTAssert(newMoonPos!.moon.date == testDate2, "moon date = \(newMoonPos!.moon.date.toString(format: .cocoaDateTime)!) and testDate1 = \(testDate2.toString(format: .cocoaDateTime)!)")
    }

    func testFindNextWaxingCrescent() throws {
        let testDate1 = Date(fromString: "2022-08-27 01:17:00 -0700")!
        let testDate2 = Date(fromString: "2022-09-25 14:55:00 -0700")!

        let dateDelta = testDate2.timeIntervalSince1970 - testDate1.timeIntervalSince1970
        let waxingCrescentDelta = Double(dateDelta / 8.0)
        let waxingDate = testDate1.addingTimeInterval(waxingCrescentDelta)

        let tdStart = Date(fromString: "2022-08-27 01:17:00 -0700")!
        let tdStop = Date(fromString: "2022-09-03 11:07:00 -0700")!
        let tdDelta = Double((tdStop.timeIntervalSince1970 - tdStart.timeIntervalSince1970) / 2.0)
        let waxingTestDate = tdStart.addingTimeInterval(tdDelta)
        XCTAssert(waxingDate == waxingTestDate, "waxingDate = \(waxingDate.toString(format: .cocoaDateTime)!) and testDate = \(waxingTestDate.toString(format: .cocoaDateTime)!)")
    }

}
