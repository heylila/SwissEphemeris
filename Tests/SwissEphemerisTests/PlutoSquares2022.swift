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

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    static var birthDate: Date {
        let dob = "1983-03-17 09:45:00 -0500"
        let dobDate = Date(fromString: dob, format: .cocoaDateTime)!
        return dobDate
    }

    static var houseSystem: HouseCusps {
        let lat: Double = 41.49932
        let long: Double = -81.69436
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testPlutoSquares() throws {
        let natalPluto = Coordinate(body: Planet.pluto, date: PlutoSquares2022.birthDate)
        let start = Date(fromString: "2022-02-16 12:00:00 -0800", format: .cocoaDateTime)!
        let end = Date(fromString: "2023-12-19 12:00:00 -0800", format: .cocoaDateTime)!
        let daySlice = Double(24 * 60 * 60)

        func filterPredicate<First, Second>(other: Coordinate<Second>, degree: Double, orb: Double) -> (Coordinate<First>) -> Bool {
            return { (first) in
                let degreeRange = (degree - orb) ... (degree + orb)
                return degreeRange.contains(first.longitudeDelta(other: other))
            }
        }

        let plutoPositions = BodiesRequest(body: Planet.pluto).fetch(start: start, end: end, interval: daySlice)
            .filter(filterPredicate(other: natalPluto, degree: 90.0, orb: 1.0))

        print("date,natal longitude,live longitude")
        for position in plutoPositions {
            let liveLongitude = preciseRound(position.longitude, precision: .hundredths)
            let natalLongitude = preciseRound(natalPluto.longitude, precision: .hundredths)
            let dateString = position.date.toString(format: .cocoaDateTime)!
            print("\(dateString),\(natalLongitude),\(liveLongitude)")
        }
    }
}
