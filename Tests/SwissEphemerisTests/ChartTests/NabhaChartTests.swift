//
//  NabhaChartTests.swift
//  
//
//  Created by Sam Krishna on 12/20/22.
//

import XCTest
@testable import SwissEphemeris

final class NabhaChartTests: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        let dob = "1981-02-21 07:55:00 +0530"
        let dobDate = Date(fromString: dob, format: .cocoaDateTime)!
        return dobDate
    }

    static var chart: BirthChart {
        let lat: Double = 30.3730177
        let long: Double = 76.1469551
        return BirthChart(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testFindRisingSign() throws {
        let chart = NabhaChartTests.chart
        let asc = chart.houseCusps.ascendent
        XCTAssert(asc.sign == Zodiac.pisces)
        XCTAssert(Int(asc.degree) == 20)
    }


}
