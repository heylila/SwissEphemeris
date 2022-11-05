//
//  ClevelandTransits.swift
//  
//
//  Created by Sam Krishna on 10/16/22.
//

import XCTest
@testable import SwissEphemeris

final class ClevelandTransits: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        let dob = "1983-03-17 09:45:00 -0500"
        let dobDate = Date(fromString: dob, format: .cocoaDateTime)!
        return dobDate
    }

    static var testDate: Date {
        return Date(fromString: "2022-10-16 08:04:00 -0700")!
    }

    static var chart: BirthChart {
        let lat: Double = 41.49932
        let long: Double = -81.69436
        return BirthChart(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    // (CHECK) Transiting ♇ Pluto sextile with natal ☉ Sun (orb: 2.0), start date: 2022-05-25 17:06:00 -0700 and end date: 2023-01-24 18:25:00 -0800
    // Pluto Sextile Sun 5-25-2022 until 1-24-2023
    func testPlutoSextileSun() throws {
        let chart = ClevelandTransits.chart
        let testDate = ClevelandTransits.testDate
        let body = Planet.pluto.celestialObject
        let natal = chart.sun
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .sextile)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 5)
            XCTAssert(first.date.component(.day) == 25)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 1)
            XCTAssert(last.date.component(.day) == 24)
            XCTAssert(last.date.component(.year) == 2023)
        }
    }

    // Mercury Trine Ascendant 10-13-2022 until 10-16-2022
    func testMercuryTrineAscendant() throws {
        let chart = ClevelandTransits.chart
        let asc = chart.houseCusps.ascendent
        let testDate = ClevelandTransits.testDate
        let body = Planet.mercury.celestialObject
        let boundaries = chart.transitingCoordinates(for: body, with: asc, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: asc, on: testDate)
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

    // (CHECK) Transiting ♅ Uranus sextile with natal ☿ Mercury (orb: 2.0), start date: 2022-05-28 19:55:00 -0700 and end date: 2022-11-27 22:10:00 -0800
    // Uranus Sextile Mercury 5-28-2022 until 11-27-2022
    func testUranusSextileMercury() throws {
        let chart = ClevelandTransits.chart
        let testDate = ClevelandTransits.testDate
        let body = Planet.uranus.celestialObject
        let natal = chart.mercury
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .sextile)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 5)
            XCTAssert(first.date.component(.day) == 28)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 11)
            XCTAssert(last.date.component(.day) == 27)
            XCTAssert(last.date.component(.year) == 2022)
        }
    }

    // (CHECK) Transiting ♇ Pluto square with natal ♀ Venus (orb: 2.0), start date: 2021-12-28 02:06:00 -0800 and end date: 2023-03-14 05:35:00 -0700
    // Pluto Square Venus 12-28-2021 until 3-14-2023
    func testPlutoSquareVenus() throws {
        let chart = ClevelandTransits.chart
        let testDate = ClevelandTransits.testDate
        let body = Planet.pluto.celestialObject
        let natal = chart.venus
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .square)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 12)
            XCTAssert(first.date.component(.day) == 28)
            XCTAssert(first.date.component(.year) == 2021)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 3)
            XCTAssert(last.date.component(.day) == 14)
            XCTAssert(last.date.component(.year) == 2023)
        }
    }

    // (CHECK) Transiting ☿ Mercury sextile with natal ♅ Uranus (orb: 2.5), start date: 2022-10-15 10:09:00 -0700 and end date: 2022-10-18 13:30:00 -0700
    // Mercury Sextile Uranus 10-15-2022 until 10-18-2022
    func testMercurySextileUranus() throws {
        let chart = ClevelandTransits.chart
        let testDate = ClevelandTransits.testDate
        let body = Planet.mercury.celestialObject
        let natal = chart.uranus
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .sextile)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 10)
            XCTAssert(first.date.component(.day) == 15)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 10)
            XCTAssert(last.date.component(.day) == 18)
            XCTAssert(last.date.component(.year) == 2022)
        }
    }

    // (CHECK) Transiting ♃ Jupiter square with natal ♆ Neptune (orb: 2.0), start date: 2022-10-16 08:07:00 -0700 and end date: 2022-12-31 12:07:00 -0800
    // Jupiter Square Neptune 10-16-2022 until 12-31-2022
    func testJupiterSquareNeptune() throws {
        let chart = ClevelandTransits.chart
        let testDate = ClevelandTransits.testDate
        let body = Planet.jupiter.celestialObject
        let natal = chart.neptune
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .square)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 10)
            XCTAssert(first.date.component(.day) == 16)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 12)
            XCTAssert(last.date.component(.day) == 31)
            XCTAssert(last.date.component(.year) == 2022)
        }
    }

    // (CHECK) Transiting ♃ Jupiter square with natal ☋ Mean South Node (orb: 2.0), start date: 2022-10-10 15:21:00 -0700 and end date: 2023-01-05 20:12:00 -0800
    // Jupiter Square SN 10-10-2022 until 1-5-2023
    func testJupiterSquareSouthNode() throws {
        let chart = ClevelandTransits.chart
        let testDate = ClevelandTransits.testDate
        let body = Planet.jupiter.celestialObject
        let natal = chart.southNode
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .square)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 10)
            XCTAssert(first.date.component(.day) == 10)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 1)
            XCTAssert(last.date.component(.day) == 5)
            XCTAssert(last.date.component(.year) == 2023)
        }
    }

    // (CHECK) Transiting ♃ Jupiter square with natal ☊ Mean (North) Node (orb: 2.0), start date: 2022-10-10 15:21:00 -0700 and end date: 2023-01-05 20:12:00 -0800
    // Jupiter Square NN 10-10-2022 until 1-5-2023
    func testJupiterSquareNorthNode() throws {
        let chart = ClevelandTransits.chart
        let testDate = ClevelandTransits.testDate
        let body = Planet.jupiter.celestialObject
        let natal = chart.northNode
        let boundaries = chart.transitingCoordinates(for: body, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .square)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 10)
            XCTAssert(first.date.component(.day) == 10)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 1)
            XCTAssert(last.date.component(.day) == 5)
            XCTAssert(last.date.component(.year) == 2023)
        }
    }

    func testAspectsForDate() throws {
        let chart = ClevelandTransits.chart
        let testDate = ClevelandTransits.testDate

        if let sunAspects = chart.aspects(for: chart.sun, on: testDate) {
            XCTAssertTrue(sunAspects.count == 1, "aspects = \(sunAspects.count)")
        }

        if let mercuryAspects = chart.aspects(for: chart.mercury, on: testDate) {
            XCTAssertTrue(mercuryAspects.count == 1, "aspects = \(mercuryAspects.count)")
        }

        if let venusAspects = chart.aspects(for: chart.venus, on: testDate) {
            XCTAssertTrue(venusAspects.count == 1, "aspects = \(venusAspects.count)")
        }

        if let marsAspects = chart.aspects(for: chart.mars, on: testDate) {
            XCTAssertTrue(marsAspects.count == 1, "aspects = \(marsAspects.count)")
        }

        if let jupiterAspects = chart.aspects(for: chart.jupiter, on: testDate) {
            XCTAssertTrue(jupiterAspects.count == 1, "aspects = \(jupiterAspects.count)")
        }

        if let saturnAspects = chart.aspects(for: chart.saturn, on: testDate) {
            XCTAssertTrue(saturnAspects.count == 1, "aspects = \(saturnAspects.count)")
        }

        if let uranusAspects = chart.aspects(for: chart.uranus, on: testDate) {
            XCTAssertTrue(uranusAspects.count == 1, "aspects = \(uranusAspects.count)")
        }

        if let neptuneAspects = chart.aspects(for: chart.neptune, on: testDate) {
            XCTAssertTrue(neptuneAspects.count == 1, "aspects = \(neptuneAspects.count)")
        }

        if let plutoAspects = chart.aspects(for: chart.pluto, on: testDate) {
            XCTAssertTrue(plutoAspects.count == 1, "aspects = \(plutoAspects.count)")
        }

        if let chironAspects = chart.aspects(for: chart.chiron, on: testDate) {
            XCTAssertTrue(chironAspects.count == 1, "aspects = \(chironAspects.count)")
        }

        if let northNodeAspects = chart.aspects(for: chart.northNode, on: testDate) {
            XCTAssertTrue(northNodeAspects.count == 1, "aspects = \(northNodeAspects.count)")
        }

        if let southNodeAspects = chart.aspects(for: chart.southNode, on: testDate) {
            XCTAssertTrue(southNodeAspects.count == 1, "aspects = \(southNodeAspects.count)")
        }
    }
}
