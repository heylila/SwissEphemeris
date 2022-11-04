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

    func testAllAspects() throws {
        let chart = BirthChartTests.chart
        let aspectCount = chart.allAspects?.count ?? 0
        XCTAssert(aspectCount == 32, "Aspect count is \(aspectCount)")
    }

    func testFindNextAspectOfJupiterAndMercury() throws {
        let date = Date(fromString: "2022-11-03 20:00:00 -0700")!
        let chart = ColumbiaTransits.chart
        let body = Planet.sun.celestialObject
        let TBody = Coordinate(body: body, date: date)
        let a = CelestialAspect(body1: TBody, body2: chart.mercury, orb: 2.0)
        XCTAssertNil(a)

        // Aspect type: conjunction on date: 2022-11-19 20:00:00 -0800
        // open: 2022-11-18 23:57:00 -0800
        // close: 2022-11-22 22:59:00 -0800

        let tuple = chart.findNextAspect(for: body, with: chart.mercury, on: date)
        XCTAssert(tuple.aspect.kind == .conjunction)
        let aspectDate = tuple.aspect.body1.date
        XCTAssert(aspectDate.component(.month) == 11)
        XCTAssert(aspectDate.component(.day) == 19)
        XCTAssert(aspectDate.component(.year) == 2022)

        let window = chart.transitingCoordinates(for: body, with: chart.mercury, on: tuple.aspect.body1.date)
        if let openDate = window?.first.date {
            XCTAssert(openDate.component(.month) == 11)
            XCTAssert(openDate.component(.day) == 18)
        }

        if let closeDate = window?.last.date {
            XCTAssert(closeDate.component(.month) == 11)
            XCTAssert(closeDate.component(.day) == 22)
            XCTAssert(closeDate.component(.hour) == 22)
        }

        print("open: \(window!.first.date.toString(format: .cocoaDateTime)!)")
        print("close: \(window!.last.date.toString(format: .cocoaDateTime)!)")
    }

}
