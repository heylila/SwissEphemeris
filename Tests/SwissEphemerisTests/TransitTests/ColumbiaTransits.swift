//
//  ColumbiaTransits.swift
//  
//
//  Created by Sam Krishna on 10/16/22.
//

import XCTest
@testable import SwissEphemeris

final class ColumbiaTransits: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        let dob = "1972-10-29 17:00:00 -0600"
        let dobDate = Date(fromString: dob, format: .cocoaDateTime)!
        return dobDate
    }

    static var testDate: Date {
        return Date(fromString: "2022-10-16 22:30:00 -0700")!
    }

    static var chart: BirthChart {
        let lat: Double = 38.9517053
        let long: Double = -92.3340724
        return BirthChart(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    // Uranus Squaring Moon 10-12-2022 until 4-22-2023
    func testUranusSquareMoon() throws {
        let chart = ColumbiaTransits.chart
        let testDate = ColumbiaTransits.testDate
        let body = Planet.uranus.celestialObject
        let natal = chart.moon
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .square)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 10)
            XCTAssert(first.date.component(.day) == 12)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 4)
            XCTAssert(last.date.component(.day) == 22)
            XCTAssert(last.date.component(.year) == 2023)
        }
    }

    // North Node Squaring Moon 8-6-2022 until 10-21-2022
    func testNorthNodeSquareMoon() throws {
        let chart = ColumbiaTransits.chart
        let testDate = ColumbiaTransits.testDate
        let body = LunarNode.meanNode.celestialObject
        let natal = chart.moon
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .square)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 8)
            XCTAssert(first.date.component(.day) == 6)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 10)
            XCTAssert(last.date.component(.day) == 21)
            XCTAssert(last.date.component(.year) == 2022)
        }
    }

    // South Node Squaring Moon 8-6-2022 until 10-21-2022
    func testSouthNodeSquareMoon() throws {
        let chart = ColumbiaTransits.chart
        let testDate = ColumbiaTransits.testDate
        let body = LunarNode.meanSouthNode.celestialObject
        let natal = chart.moon
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .square)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 8)
            XCTAssert(first.date.component(.day) == 6)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 10)
            XCTAssert(last.date.component(.day) == 21)
            XCTAssert(last.date.component(.year) == 2022)
        }
    }

    // Venus Trine Saturn 10-13-2022 until 10-16-2022
    func testVenusTrineSaturn() throws {
        let chart = ColumbiaTransits.chart
        let testDate = Date(fromString: "2022-10-15 22:30:00 -0700")!
        let body = Planet.venus.celestialObject
        let natal = chart.saturn
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .trine)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 10)
            XCTAssert(first.date.component(.day) == 13)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 10)
            XCTAssert(last.date.component(.day) == 16)
            XCTAssert(last.date.component(.year) == 2022)
        }
    }

    // Jupiter Trine Mercury 10-9-2022 until 12-29-2022
    // There's some retrograde action here which is what makes is so weird
    func testJupiterTrineMercury() throws {
        let chart = ColumbiaTransits.chart
        let testDate = ColumbiaTransits.testDate
        let body = Planet.jupiter.celestialObject
        let natal = chart.mercury
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate, orb: 2.5)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate, orb: 2.5)
        XCTAssert(kind == .trine)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 10)
            XCTAssert(first.date.component(.day) == 13)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 1)
            XCTAssert(last.date.component(.day) == 2)
            XCTAssert(last.date.component(.year) == 2023)
        }
    }

    // Saturn Trine Mars 8-28-2022 until 12-14-2022
    func testSaturnTrineMars() throws {
        let chart = ColumbiaTransits.chart
        let testDate = ColumbiaTransits.testDate
        let body = Planet.saturn.celestialObject
        let natal = chart.mars
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .trine)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 8)
            XCTAssert(first.date.component(.day) == 28)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 12)
            XCTAssert(last.date.component(.day) == 14)
            XCTAssert(last.date.component(.year) == 2022)
        }
    }

    // Saturn Trine Saturn 8-14-2022 until 12-26-2022
    func testSaturnTrineSaturn() throws {
        let chart = ColumbiaTransits.chart
        let testDate = ColumbiaTransits.testDate
        let body = Planet.saturn.celestialObject
        let natal = chart.saturn
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .trine)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 8)
            XCTAssert(first.date.component(.day) == 14)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 12)
            XCTAssert(last.date.component(.day) == 26)
            XCTAssert(last.date.component(.year) == 2022)
        }
    }

    // Venus Conjunct Uranus 10-13-2022 until 10-16-2022
    func testVenusConjunctUranus() throws {
        let chart = ColumbiaTransits.chart
        let testDate = Date(fromString: "2022-10-15 22:30:00 -0700")!
        let body = Planet.venus.celestialObject
        let natal = chart.uranus
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .conjunction)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 10)
            XCTAssert(first.date.component(.day) == 13)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 10)
            XCTAssert(last.date.component(.day) == 16)
            XCTAssert(last.date.component(.year) == 2022)
        }
    }

    // Saturn Trine Uranus 8-15-2022 until 12-25-2022
    func testSaturnTrineUranus() throws {
        let chart = ColumbiaTransits.chart
        let testDate = ColumbiaTransits.testDate
        let body = Planet.saturn.celestialObject
        let natal = chart.uranus
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .trine)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 8)
            XCTAssert(first.date.component(.day) == 15)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 12)
            XCTAssert(last.date.component(.day) == 25)
            XCTAssert(last.date.component(.year) == 2022)
        }
    }

    func test2ndHouseRuler() throws {
        let chart = ColumbiaTransits.chart
        let saturn = chart.saturn;
        let testCusp = chart.houseCusps.cuspForLongitude(saturn.longitude)
        let ruler = chart.houseCusps.rulersForCusp(testCusp!)
        XCTAssert(ruler.contains(Planet.mercury))
    }

    func test7thHouseRulers() throws {
        let chart = ColumbiaTransits.chart
        let sun = chart.sun;
        let testCusp = chart.houseCusps.cuspForLongitude(sun.longitude)
        let rulers = chart.houseCusps.rulersForCusp(testCusp!)
        XCTAssert(rulers.contains(Planet.mars))
        XCTAssert(rulers.contains(Planet.pluto))

    }

    func testScenario3() throws {
        let now = Date(fromString: "2023-02-08 22:05:00 -0800")!
        let moon = Coordinate(body: Planet.moon.celestialObject, date: now)
        let chart = ColumbiaTransits.chart

        // Step 1: find the house that the transiting moon is in.
        let cusp = chart.houseCusps.cuspForLongitude(moon.longitude)

        // Step 2: Look up the sign on the cusp of that house.
        // Step 3: Look up the ruler(s) of that sign. Note: in some cases, the house will have 2 rulers and we will display transits to both planetary rulers.
        let rulers = chart.houseCusps.rulersForCusp(cusp!)
        XCTAssert(rulers.count == 1)
        XCTAssert(rulers.contains(Planet.mercury))
        let rulerObject = rulers.first!
        let natalRuler = chart.allBodies.filter { $0.body == rulerObject.celestialObject }.first!

        // Step 4: Display all current transits to the ruler.
        let aspects = chart.aspects(for: natalRuler, on: now)!
        XCTAssert(aspects.count == 3)
    }

//    func testFindPeakCoordinate() throws {
//        let chart = ColumbiaTransits.chart
//        let testDate = ColumbiaTransits.testDate
//        let body = Planet.saturn.celestialObject
//        let natal = chart.uranus
//        if let peak = chart.findPeakCoordinate(for: body, with: natal, on: testDate) {
//            print("\(peak)")
//        }
//    }
}
