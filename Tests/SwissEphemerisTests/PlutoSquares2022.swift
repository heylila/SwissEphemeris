//
//  PlutoSquares2022.swift
//  
//
//  Created by Sam Krishna on 4/4/22.
//

import XCTest
@testable import SwissEphemeris

class PlutoSquares2022: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        let dob = "1983-03-17 09:45:00 -0500"
        let dobDate = Date(fromString: dob, format: .cocoaDateTime)!
        return dobDate
    }

    static var chart: HouseCusps {
        let lat: Double = 41.49932
        let long: Double = -81.69436
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testAspectsAndPairs() throws {
        let chart = PlutoSquares2022.chart
        let natalVenus = Coordinate(body: Planet.venus.celestialObject, date: chart.date)

        let start = Date(fromString: "2021-03-01 00:00:00 +0000", format: .cocoaDateTime)!
        let end = Date(fromString: "2021-06-30 23:59:00 +0000", format: .cocoaDateTime)!

        let positions = BodiesRequest(body: Planet.pluto.celestialObject).fetch(start: start, end: end, interval: TimeSlice.hour.slice)
        let orb = 1.5

        let squares = positions.filter { Tpluto in
            let a = Aspect(bodyA: Tpluto, bodyB: natalVenus, orb: orb)
            return (a != nil && a!.isSquare)
        }

        let squareFirst = squares.first!

        XCTAssert(squareFirst.date.component(.month)! == 3)
        XCTAssert(squareFirst.date.component(.day)! == 13)
        XCTAssert(squareFirst.date.component(.year)! == 2021)
    }

    func testAllSquares() throws {
        let chart = PlutoSquares2022.chart
        let natalVenus = Coordinate(body: Planet.venus.celestialObject, date: chart.date)
        let start = Date(fromString: "2021-01-01 00:00:00 +0000", format: .cocoaDateTime)!
        let end = Date(fromString: "2023-12-31 23:59:00 +0000", format: .cocoaDateTime)!

        let positions = BodiesRequest(body: Planet.pluto.celestialObject).fetch(start: start, end: end, interval: TimeSlice.hour.slice)
        let orb = 1.5

        let squares = positions.filter { Tpluto in
            if let a = Aspect(bodyA: Tpluto, bodyB: natalVenus, orb: orb) {
                return a.isSquare
            }
            
            return false
        }

        let squareOffsets = Array(squares.dropFirst()) + [squares.first!]
        var tGroup = [Coordinate]()
        var tGroups = [[Coordinate]]()

        for (now, next) in zip(squares, squareOffsets) {
            if tGroup.count == 0 {
                tGroup.append(now)
                continue
            }

            if next.date.since(now.date, in: .day)! > 1 || next.date.since(now.date, in: .day)! < 0 {
                tGroup.append(now)
                tGroups.append(tGroup)
                tGroup.removeAll()
            }
        }

        XCTAssert(tGroups.count == 4)
    }

    func testCelestialAspect() throws {
        let chart = PlutoSquares2022.chart
        let natalVenus = Coordinate(body: Planet.venus.celestialObject, date: chart.date)
        let start = Date(fromString: "2021-01-01 00:00:00 +0000", format: .cocoaDateTime)!
        let end = Date(fromString: "2023-12-31 23:59:00 +0000", format: .cocoaDateTime)!

        let positions = BodiesRequest(body: Planet.pluto.celestialObject).fetch(start: start, end: end, interval: TimeSlice.hour.slice)
        let orb = 1.5

        let squares = positions.filter { Tpluto in
            if let ca = CelestialAspect(body1: Tpluto, body2: natalVenus, orb: orb) {
                print("ca = \(ca)")
            }
//            if let a = Aspect(bodyA: Tpluto, bodyB: natalVenus, orb: orb) {
//                return a.isSquare
//            }

            return false
        }
    }
}
