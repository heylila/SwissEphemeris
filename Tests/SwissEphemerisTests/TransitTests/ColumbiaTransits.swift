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

    static var chart: BirthChart {
        let lat: Double = 38.9517053
        let long: Double = -92.3340724
        return BirthChart(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    // Uranus Squaring Moon 10-12-2022 until 4-22-2023
    func testUranusSquareMoon() throws {
        let chart = ColumbiaTransits.chart
        let testDate = Date(fromString: "2022-10-16 22:30:00 -0700")!
        let body = Planet.uranus
        let natal = chart.moon
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

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
        let testDate = Date(fromString: "2022-10-16 22:30:00 -0700")!
        let body = LunarNode.meanNode
        let natal = chart.moon
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

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
        let testDate = Date(fromString: "2022-10-16 22:30:00 -0700")!
        let body = LunarNode.meanSouthNode
        let natal = chart.moon
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

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
        let body = Planet.venus
        let TBody = Coordinate(body: body, date: testDate)
        let natal = chart.saturn
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

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
    func testJupiterTrineMercury() throws {
        let chart = ColumbiaTransits.chart
        let testDate = Date(fromString: "2022-10-16 22:30:00 -0700")!
        let body = Planet.jupiter
        let TBody = Coordinate(body: body, date: testDate)
        let natal = chart.mercury
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

        if let first = boundaries?.first {
            XCTAssert(first.date.component(.month) == 10)
            XCTAssert(first.date.component(.day) == 13)
            XCTAssert(first.date.component(.year) == 2022)
        }

        if let last = boundaries?.last {
            XCTAssert(last.date.component(.month) == 12)
            XCTAssert(last.date.component(.day) == 29)
            XCTAssert(last.date.component(.year) == 2023)
        }
    }

    // Saturn Trine Mars 8-28-2022 until 12-14-2022
    func testSaturnTrineMars() throws {
        let chart = ColumbiaTransits.chart
        let testDate = Date(fromString: "2022-10-16 22:30:00 -0700")!
        let body = Planet.saturn
        let natal = chart.mars
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

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
        let testDate = Date(fromString: "2022-10-16 22:30:00 -0700")!
        let body = Planet.saturn
        let natal = chart.saturn
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

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
        let body = Planet.venus
        let natal = chart.uranus
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

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
        let testDate = Date(fromString: "2022-10-16 22:30:00 -0700")!
        let body = Planet.saturn
        let natal = chart.uranus
        let TBody = Coordinate(body: body, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TBody, with: natal, on: testDate)
        XCTAssertNotNil(boundaries)

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
}
