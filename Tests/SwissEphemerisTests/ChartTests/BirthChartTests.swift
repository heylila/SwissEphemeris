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

        let startDate = tuple.start.date
        XCTAssert(startDate.component(.month) == 11)
        XCTAssert(startDate.component(.day) == 18)

        let endDate = tuple.end.date
        XCTAssert(endDate.component(.month) == 11)
        XCTAssert(endDate.component(.day) == 22)
        XCTAssert(endDate.component(.hour) == 22)
    }

    func testFindAllNextAspectsForEachNatalBody() throws {
        let chart = ClevelandTransits.chart
        var earliestAspects = [(aspect: CelestialAspect, start: Coordinate, end: Coordinate)]()
        let date = Date(fromString: "2022-11-04 12:00:00 -0700")!
        let allBodyCases = BirthChart.allBodyCases.filter{ $0 != Planet.moon.celestialObject }

        for natal in chart.allBodies {
            var tupleArray = [(aspect: CelestialAspect, start: Coordinate, end: Coordinate)]()

            for TBody in allBodyCases {
                let tuple = chart.findNextAspect(for: TBody, with: natal, on: date)
                tupleArray.append(tuple)
            }

            let min = tupleArray.min { lhs, rhs in
                return lhs.start.date < rhs.start.date
            }

            earliestAspects.append(min!)
        }

        for tuple in earliestAspects {
            let TBody = tuple.aspect.body1.body
            let natal = tuple.aspect.body2
            print("For T-body: \(TBody.formatted) \(tuple.aspect.kind) Natal \(natal.formatted), open date: \(tuple.start.date.toString(format: .cocoaDateTime)!) and close date: \(tuple.end.date.toString(format: .cocoaDateTime)!)")
        }
    }

    func testFindAllNextAspectsForAscendant() throws {
        let chart = ClevelandTransits.chart
        let asc = chart.houseCusps.ascendent
        let testDate = ClevelandTransits.testDate
        let body = Planet.mercury.celestialObject
        let aspect = chart.findNextAspect(for: body, with: asc, on: testDate)

        // Mercury Trine Ascendant 10-13-2022 until 10-16-2022
        let start = aspect.start.date
        let end = aspect.end.date

        XCTAssert(start.component(.month) == 10)
        XCTAssert(start.component(.day) == 13)
        XCTAssert(start.component(.year) == 2022)

        XCTAssert(end.component(.month) == 10)
        XCTAssert(end.component(.day) == 16)
        XCTAssert(end.component(.year) == 2022)

        for body in BirthChart.allBodyCases {
            let window = chart.findNextAspect(for: body, with: asc, on: testDate)
            XCTAssertNotNil(window)
            XCTAssert(window.aspect.body.body == body)
        }
    }
}
