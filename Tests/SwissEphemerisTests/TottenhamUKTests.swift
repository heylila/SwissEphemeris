//
//  TottenhamUKTests.swift
//  
//
//  Created by Sam Krishna on 3/7/22.
//

import XCTest
@testable import SwissEphemeris

/// As a user, I want to be able to generate the expected results from a transiting moon aspect to a natal chart in order to be able to check the accuracy of my code.
///
/// In order to do this, I need to generate a "testable" birth chart (birth date, location, and time) that I can use to look for transiting aspects from the Moon.
///
/// When I input the Moon's location by degree, I can generate:
/// - A "testable" birth chart – the birth date, the birth time, and the birth location – one that contains planets in that sign (a specific degree range).
/// - The exact date and time (in UTC) of the conjunction aspect from the Moon to planets in that sign (a specific degree range).
/// - A four hour range for the event spanning from exactly 2 hours before to 2 hours after (in UTC).

// All Lunar conjunctions with Birth Chart planets over any given 7 day window
// +/-2 hours in either direction of the conjunction
// Include the time of the precise (as close to 0° for the conjunction) to the minute

class TottenhamUKTests: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    // Birthdate: 1988-05-05 02:02:00 UTC
    // Tottenham, England, UK
    // Lat: 51.6055748
    // Long: -0.0681665

    static var birthDate: Date {
        return Date(fromString: "1988-05-05 02:02:00 +0000", format: .cocoaDateTime, timeZone: .utc)!
    }

    static var houseSystem: HouseCusps {
        let lat = 51.6055748
        let long = -0.0681665
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    static var planets: [String : Coordinate<Planet>] {
        let dict = [
            Planet.sun.formatted : Coordinate(body: Planet.sun, date: birthDate),
            Planet.moon.formatted : Coordinate(body: .moon, date: birthDate),
            Planet.mercury.formatted : Coordinate(body: .mercury, date: birthDate),
            Planet.venus.formatted : Coordinate(body: .venus, date: birthDate),
            Planet.mars.formatted : Coordinate(body: .mars, date: birthDate),
            Planet.jupiter.formatted : Coordinate(body: .jupiter, date: birthDate),
            Planet.saturn.formatted : Coordinate(body: .saturn, date: birthDate),
            Planet.uranus.formatted : Coordinate(body: .uranus, date: birthDate),
            Planet.neptune.formatted : Coordinate(body: .neptune, date: birthDate),
            Planet.pluto.formatted : Coordinate(body: .pluto, date: birthDate)
        ]

        return dict
    }

    func testTottenhamUKConjunctions() throws {
        let start = Date(fromString: "2022-03-06 13:00:00 -0800", format: .cocoaDateTime)!
        let end = start.offset(.day, value: 7)!
        var moonConjunctions = [String : Coordinate<Planet>]()

        for (planetName, planet) in TottenhamUKTests.planets {
            let nearestHourMoonPosition = PlanetsRequest(body: .moon).fetch(start: start, end: end, interval: Double(60 * 60))
                .filter { $0.longitudeDelta(other: planet) < 1 }
                .min { lhs, rhs in
                    return lhs.longitudeDelta(other: planet) < rhs.longitudeDelta(other: planet)
                }

            guard let nearestHourMoonPosition = nearestHourMoonPosition else {
                print("Skipping \(planetName)")
                continue
            }

            let detailDate = nearestHourMoonPosition.date

            let minStart = detailDate.offset(.minute, value: -30)!
            let minEnd = detailDate.offset(.minute, value: 30)!

            // Then slice it to the per-minute basis next
            let nearestMinuteMoonPosition = PlanetsRequest(body: .moon).fetch(start: minStart, end: minEnd, interval: 60.0)
                .min { lhs, rhs in
                    return lhs.longitudeDelta(other: planet) < rhs.longitudeDelta(other: planet)
                }

            guard let nearestMinuteMoonPosition = nearestMinuteMoonPosition else {
                continue
            }

            moonConjunctions[planetName] = nearestMinuteMoonPosition
        }

        // Birthdate: 1988-05-05 02:02:00 UTC
        // Tottenham, England, UK
        print("With a birth chart of 1988-05-05 02:02:00 UTC at Tottenham, England, UK")
        print("From a start time of " + start.toString(format: .cocoaDateTime, timeZone: .utc)! + " + 7 days...")
        for (planetName, planet) in moonConjunctions {
            print("\(planetName)\'s closest moon time is \(planet.date)")
        }

        XCTAssertTrue(moonConjunctions.count == 4)
    }
}
