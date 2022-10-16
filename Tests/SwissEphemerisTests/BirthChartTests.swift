//
//  BirthChartTests.swift
//  
//
//  Created by Sam Krishna on 10/13/22.
//

import XCTest
@testable import SwissEphemeris

final class BirthChartTests: XCTestCase {

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

    func testPlanetaryAspects() throws {
        let chart = BirthChartTests.chart
        XCTAssert(chart.planetToPlanetAspects?.count == 17)
    }

    func testPlanetToChironAspects() throws {
        let chart = BirthChartTests.chart
        XCTAssert(chart.planetToChironAspects?.count == 2)
    }

    func testPlanetToNodeAspects() throws {
        let chart = BirthChartTests.chart
        let aspects = chart.planetToNodeAspects!
        let aspectCount = aspects.count
        XCTAssert(aspectCount == 12, "Aspect count is \(aspectCount)")

        for aspect in aspects {
            print("\(aspect.aspectString)")
        }
    }

    func testChironToNodeAspects() throws {
        let chart = BirthChartTests.chart
        let aspectCount = chart.chironToNodeAspects?.count ?? 0
        XCTAssert(aspectCount == 0, "Aspect count is \(aspectCount)")
    }

}
