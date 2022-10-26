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

    static var chart: BirthChart {
        let lat: Double = 41.49932
        let long: Double = -81.69436
        return BirthChart(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    // Pluto Sextile Sun 5-25-2022 until 1-24-2023
    func testPlutoSextileSun() throws {
        let chart = ClevelandTransits.chart
        let testDate = Date(fromString: "2022-10-16 08:04:00 -0700")!
        let body = Planet.pluto.celestialObject
        let TBody = Coordinate(body: body, date: testDate)
        let natal = chart.sun
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
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
        let testDate = Date(fromString: "2022-10-16 08:04:00 -0700")!
        let body = Planet.mercury.celestialObject
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: asc, on: testDate)
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

    // Uranus Sextile Mercury 5-28-2022 until 11-27-2022
    func testUranusSextileMercury() throws {
        let chart = ClevelandTransits.chart
        let testDate = Date(fromString: "2022-10-16 08:04:00 -0700")!
        let body = Planet.uranus.celestialObject
        let TBody = Coordinate(body: body, date: testDate)
        let natal = chart.mercury
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
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

    // Pluto Square Venus 12-28-2021 until 3-14-2023
    func testPlutoSquareVenus() throws {
        let chart = ClevelandTransits.chart
        let testDate = Date(fromString: "2022-10-16 08:04:00 -0700")!
        let body = Planet.pluto.celestialObject
        let TBody = Coordinate(body: body, date: testDate)
        let natal = chart.venus
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
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

    // Mercury Sextile Uranus 10-15-2022 until 10-18-2022
    func testMercurySextileUranus() throws {
        let chart = ClevelandTransits.chart
        let testDate = Date(fromString: "2022-10-16 08:04:00 -0700")!
        let body = Planet.mercury.celestialObject
        let natal = chart.uranus
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
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

    // Jupiter Square Neptune 10-16-2022 until 12-31-2022
    func testJupiterSquareNeptune() throws {
        let chart = ClevelandTransits.chart
        let testDate = Date(fromString: "2022-10-16 08:04:00 -0700")!
        let body = Planet.jupiter.celestialObject
        let natal = chart.neptune
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
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

    // Jupiter Square SN 10-10-2022 until 1-5-2023
    func testJupiterSquareSouthNode() throws {
        let chart = ClevelandTransits.chart
        let testDate = Date(fromString: "2022-10-16 08:04:00 -0700")!
        let body = Planet.jupiter.celestialObject
        let natal = chart.southNode
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        let kind = chart.transitType(for: body, with: natal, on: testDate)
        XCTAssert(kind == .trine)

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

    // Jupiter Square NN 10-10-2022 until 1-5-2023
    func testJupiterSquareNorthNode() throws {
        let chart = ClevelandTransits.chart
        let testDate = Date(fromString: "2022-10-16 08:04:00 -0700")!
        let body = Planet.jupiter.celestialObject
        let natal = chart.northNode
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
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
}
