//
//  ClevelandTransits.swift
//  
//
//  Created by Sam Krishna on 10/16/22.
//

import XCTest
@testable import SwissEphemeris

final class ClevelandTransits: XCTestCase {

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
    // Mercury Trine Ascendant 10-13-2022 until 10-16-2022
    // Uranus Sextile Mercury 5-28-2022 until 11-27-2022
    // Pluto Square Venus 12-28-2021 until 3-14-2023
    // Mercury Sextile Uranus 10-15-2022 until 10-18-2022
    // Jupiter Square Neptune 10-16-2022 until 12-31-2022
    // Jupiter Square SN 10-10-2022 until 1-5-2023
    // Jupiter Square NN 10-10-2022 until 1-5-2023
    func testExample() throws {
        let chart = ClevelandTransits.chart
        let testDate = Date(fromString: "2022-10-16 08:04:00 -0700")!
        let TPluto = Coordinate(body: Planet.pluto, date: testDate)
        let boundaries = chart.transitingCoordinates(for: TPluto, with: chart.sun, on: testDate)
        XCTAssertNotNil(boundaries)
    }


}
