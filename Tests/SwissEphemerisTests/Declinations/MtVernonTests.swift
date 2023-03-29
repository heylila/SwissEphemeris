//
//  MtVernonTests.swift
//  
//
//  Created by Sam Krishna on 3/29/23.
//

import XCTest
@testable import SwissEphemeris

final class MtVernonTests: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        let dob = "1949-01-06 03:22:00 -0500"
        let dobDate = Date(fromString: dob, format: .cocoaDateTime)!
        return dobDate
    }

    static var chart: BirthChart {
        let lat: Double = 40.9125992
        let long: Double = -73.8370786
        return BirthChart(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    // Sun: -22° 31'
    func testSunDeclination() throws {
        let test = -22.51
        let chart = MtVernonTests.chart
        let value = preciseRound(chart.sun.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // Moon: -0° 54'
    func testMoonDeclination() throws {
        let test = -0.90
        let value = preciseRound(MtVernonTests.chart.moon.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // Mercury: -22° 06'
    func testMercuryDeclination() throws {
        let test = -22.09
        let value = preciseRound(MtVernonTests.chart.mercury.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // Venus: -22° 21'
    func testVenusDeclination() throws {
        let test = -22.34
        let chart = MtVernonTests.chart
        let value = preciseRound(chart.venus.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // Mars: -20° 58'
    func testMarsDeclination() throws {
        let test = -20.95
        let chart = MtVernonTests.chart
        let value = preciseRound(chart.mars.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // Jupiter: -22° 57'
    func testJupiterDeclination() throws {
        let test = -22.95
        let chart = MtVernonTests.chart
        let value = preciseRound(chart.jupiter.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // Saturn: +10° 55'
    func testSaturnDeclination() throws {
        let test = 10.91
        let chart = MtVernonTests.chart
        let value = preciseRound(chart.saturn.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // Uranus: +23° 38'
    func testUranusDeclination() throws {
        let test = 23.63
        let chart = MtVernonTests.chart
        let value = preciseRound(chart.uranus.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // Neptune: -4° 31'
    func testNeptuneDeclination() throws {
        let test = -4.52
        let chart = MtVernonTests.chart
        let value = preciseRound(chart.neptune.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // Pluto: +23° 27'
    func testPlutoDeclination() throws {
        let test = 23.44
        let chart = MtVernonTests.chart
        let value = preciseRound(chart.pluto.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // North Node: +11° 53'
    func testNorthNodeDeclination() throws {
        let test = 11.88
        let chart = MtVernonTests.chart
        let value = preciseRound(chart.northNode.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // Asc: -18° 29'
    func testAscendantDeclination() throws {
        let test = -18.48
        let chart = MtVernonTests.chart
        let value = preciseRound(chart.houseCusps.ascendent.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

    // Mid: +9° 30'
    func testMidheavenDeclination() throws {
        let test = 9.52
        let chart = MtVernonTests.chart
        let value = preciseRound(chart.houseCusps.midHeaven.declination, precision: .hundredths)
        XCTAssert(value == test, "\(value) is not the same as test: \(test)")
    }

}
