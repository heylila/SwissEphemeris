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

        let testDate = Date(fromString: "2022-09-10 02:59:00 -0700")!
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

    func testFailedAugustFirstQuarterMoon() throws {
        let startSearch = Date(fromString: "2022-08-25 00:00:00 -0700")!
        let endSearch = startSearch.offset(.day, value: 28)!
        let hourSlice = TimeSlice.hour.slice
        var suns = BodiesRequest(body: Planet.sun).fetch(start: startSearch, end: endSearch, interval: hourSlice)
        var moons = BodiesRequest(body: Planet.moon).fetch(start: startSearch, end: endSearch, interval: hourSlice)

        XCTAssert(suns.count == moons.count)

        let newMoonHourPos = Array(zip(suns, moons)).min { lhs, rhs in
            return lhs.0.longitudeDelta(other: lhs.1) < rhs.0.longitudeDelta(other: rhs.1)
        }

        let hourSearch = newMoonHourPos!.1.date
        let startSearchMin = hourSearch.offset(.minute, value: -60)!
        let endSearchMin = hourSearch.offset(.minute, value: 60)!
        suns = BodiesRequest(body: Planet.sun).fetch(start: startSearchMin, end: endSearchMin)
        moons = BodiesRequest(body: Planet.moon).fetch(start: startSearchMin, end: endSearchMin)

        let newMoonMinPos = Array(zip(suns, moons)).min { lhs, rhs in
            return lhs.0.longitudeDelta(other: lhs.1) < rhs.0.longitudeDelta(other: rhs.1)
        }

        let newMoonDate = Date(fromString: "2022-08-27 01:17:00 -0700")!
        let resultDate: Date = newMoonMinPos!.1.date
        XCTAssert(newMoonDate == resultDate, "Error! result date = \(resultDate.toString(format: .cocoaDateTime)!)")

        let fullMoonDate = Date(fromString: "2022-09-10 02:59:00 -0700")!
        let newToFullDelta = fullMoonDate.timeIntervalSince1970 - newMoonDate.timeIntervalSince1970
        let quarterMoonInterval = newToFullDelta / 2.0
        let quarterMoonDate = Date(timeInterval: quarterMoonInterval, since: newMoonDate)
        let quarteMoonControl = Date(fromString: "2022-09-03 11:0:00 -0700")!

        // This should fail because the quarter moon (and all moon phases) are based on ANGLES between the sun and moon,
        // not time distances from New to Full Moon
        XCTAssertFalse(quarterMoonDate == quarteMoonControl, "Error: quarterMoonDate = \(quarterMoonDate.toString(format: .cocoaDateTime)!)")
    }

    func testFindNextFirstQuarterMoon() throws {
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

        let testFullMoonDate = Date(fromString: "2022-09-10 02:59:00 -0700")
        XCTAssert(minPos.sun.date == testFullMoonDate)

        let newMoonDate = Date(fromString: "2022-08-27 01:17:00 -0700")!
        let fullMoonDate = minPos.sun.date
        var slice = TimeSlice.hour.slice
        var suns = BodiesRequest(body: Planet.sun).fetch(start: newMoonDate, end: fullMoonDate, interval: slice)
        var moons = BodiesRequest(body: Planet.moon).fetch(start: newMoonDate, end: fullMoonDate, interval: slice)
        let q1MoonHourPos = Array(zip(suns, moons)).min { lhs, rhs in
            return abs(90.0 - lhs.0.longitudeDelta(other: lhs.1)) < abs(90.0 - rhs.0.longitudeDelta(other: rhs.1))
        }

        guard let q1MoonHourPos = q1MoonHourPos else {
            XCTFail("Couldn't find a good hour")
            return
        }

        let startMinSearch = q1MoonHourPos.1.date.offset(.hour, value: -1)!
        let endMinSearch = q1MoonHourPos.1.date.offset(.hour, value: 1)!
        suns = BodiesRequest(body: Planet.sun).fetch(start: startMinSearch, end: endMinSearch)
        moons = BodiesRequest(body: Planet.moon).fetch(start: startMinSearch, end: endMinSearch)
        let q1MoonMinPos = Array(zip(suns, moons)).min { lhs, rhs in
            return abs(90.0 - lhs.0.longitudeDelta(other: lhs.1)) < abs(90.0 - rhs.0.longitudeDelta(other: rhs.1))
        }

        let testQuarterMoonDate = Date(fromString: "2022-09-03 11:08:00 -0700")!
        let resultDate = q1MoonMinPos!.1.date
        XCTAssert(testQuarterMoonDate == resultDate, "Error! result = \(resultDate.toString(format: .cocoaDateTime)!)")
    }


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
        // NOTE:
        // Waxing Crescent is defined as:
        // (Full Moon Date, Quarter Moon Date) <- Notice this is an OPEN interval
        // (from Math's interval notation)
        let newMoonDate = Date(fromString: "2022-08-27 01:17:00 -0700")!
        let q1MoonDate = Date(fromString: "2022-09-03 11:08:00 -0700")!
        let start = newMoonDate.offset(.minute, value: 1)!
        let end = q1MoonDate.offset(.minute, value: -1)!
        let waxingCrescent = start...end
        let fullMoonDate = Date(fromString: "2022-09-10 02:59:00 -0700")!
        var slice = TimeSlice.hour.slice
        var suns = BodiesRequest(body: Planet.sun).fetch(start: newMoonDate, end: fullMoonDate, interval: slice)
        var moons = BodiesRequest(body: Planet.moon).fetch(start: newMoonDate, end: fullMoonDate, interval: slice)
        let minWCHour = Array(zip(suns, moons)).min { lhs, rhs in
            return abs(45.0 - lhs.0.longitudeDelta(other: lhs.1)) < abs(45.0 - rhs.0.longitudeDelta(other: rhs.1))
        }

        guard let minWCHour = minWCHour else {
            XCTFail("We couldn't find a suitable hour")
            return
        }

        let startSearchMin = minWCHour.1.date.offset(.hour, value: -1)!
        let endSearchMin = minWCHour.1.date.offset(.hour, value: 1)!
        slice = TimeSlice.minute.slice
        suns = BodiesRequest(body: Planet.sun).fetch(start: newMoonDate, end: fullMoonDate, interval: slice)
        moons = BodiesRequest(body: Planet.moon).fetch(start: newMoonDate, end: fullMoonDate, interval: slice)

        let minWCMin = Array(zip(suns, moons)).min { lhs, rhs in
            return abs(45.0 - lhs.0.longitudeDelta(other: lhs.1)) < abs(45.0 - rhs.0.longitudeDelta(other: rhs.1))
        }

        let resultDate = minWCMin!.1.date
        print("result = \(resultDate.toString(format: .cocoaDateTime)!)")
//        let testDate1 = Date(fromString: "2022-08-27 01:17:00 -0700")!
//        let testDate2 = Date(fromString: "2022-09-25 14:55:00 -0700")!
//
//        let dateDelta = testDate2.timeIntervalSince1970 - testDate1.timeIntervalSince1970
//        let waxingCrescentDelta = Double(dateDelta / 8.0)
//        let waxingDate = testDate1.addingTimeInterval(waxingCrescentDelta)
//
//        let tdStart = Date(fromString: "2022-08-27 01:17:00 -0700")!
//        let tdStop = Date(fromString: "2022-09-03 11:07:00 -0700")!
//        let tdDelta = Double((tdStop.timeIntervalSince1970 - tdStart.timeIntervalSince1970) / 2.0)
//        let waxingTestDate = tdStart.addingTimeInterval(tdDelta)
//        XCTAssert(waxingDate == waxingTestDate, "waxingDate = \(waxingDate.toString(format: .cocoaDateTime)!) and testDate = \(waxingTestDate.toString(format: .cocoaDateTime)!)")
    }

}
