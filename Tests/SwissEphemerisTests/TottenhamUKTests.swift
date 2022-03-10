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

// Ultimately what we want is a tool that takes the following arguments:
//
// -planet=moon (or whatever)
// -transitType=conjunction (or trine/sextile/square/opposition)
// -birthDate="<some UTC date>"
// -lat=<some latitude>
// -long=<some longitude>
// -transitStartDate="<some UTC date AFTER the birth date>"
// -daysLookahead=7

class TottenhamUKTests: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    // Birthdate: 1988-05-05 02:02:00 UTC
    // Tottenham, England, UK
    // Lat: 51.6055748
    // Long: -0.0681665

    let conjunction: Double = 1.0
    let trine: Double = 120.0
    let square: Double = 90.0
    let opposition: Double = 180.0
    let sextile: Double = 60.0

    /// Modify `startDate` to have a different testing start date window for lunar transits
    static var testStartDate: Date {
        return Date(fromString: "2022-03-06 13:00:00 -0800", format: .cocoaDateTime, timeZone: .utc)!
    }

    static var birthDate: Date {
        return Date(fromString: "1988-05-05 02:02:00 +0000", format: .cocoaDateTime, timeZone: .utc)!
    }

    static var houseSystem: HouseCusps {
        let lat = 51.6055748
        let long = -0.0681665
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    static var planets: [String : Coordinate<Planet> ] {
        return [
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
    }

    static var nodes: [String : Coordinate<LunarNode> ] {
        return [
            "North Node" : Coordinate(body: LunarNode.trueNode, date: birthDate),
            "South Node" : Coordinate(body: LunarNode.southNode, date: birthDate)
        ]
    }

    static var chiron: Coordinate<Asteroid> {
        return Coordinate(body: Asteroid.chiron, date: birthDate)
    }

    func testTottenhamUKConjunctions() throws {
        let daysOut = 14
        let start = TottenhamUKTests.testStartDate
        let end = start.offset(.day, value: daysOut)!
        var moonConjunctions = [String : Coordinate<Planet>]()

        // 10° orb for conjunctions
        // 8° orb for oppositions and squares
        // 6° orb for trines and sextiles

        // 0° for conjunctions
        // 60° for sextiles
        // 90° for squares
        // 120° for trines
        // 180° for oppositions

        func filterPredicate<First, Second>(other: Coordinate<Second>, degree: Double, orb: Double) -> (Coordinate<First>) -> Bool {
            return { (first) in
                let degreeRange = (degree - orb / 2) ... (degree + orb / 2)
                return degreeRange.contains(first.longitudeDelta(other: other))
            }
        }

        for (planetName, planet) in TottenhamUKTests.planets {
            let nearestHourMoonPosition = PlanetsRequest(body: .moon).fetch(start: start, end: end, interval: Double(60 * 60))
                .filter(filterPredicate(other: planet, degree: 0.0, orb: 10.0))
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

        for (nodeName, node) in TottenhamUKTests.nodes {
            let nearestHourMoonPosition = PlanetsRequest(body: .moon).fetch(start: start, end: end, interval: Double(60 * 60))
                .filter(filterPredicate(other: node, degree: 0.0, orb: 10.0))
                .min { lhs, rhs in
                    return lhs.longitudeDelta(other: node.longitude) < rhs.longitudeDelta(other: node.longitude)
                }

            guard let nearestHourMoonPosition = nearestHourMoonPosition else {
                print("Skipping \(nodeName)")
                continue
            }

            let detailDate = nearestHourMoonPosition.date
            let minStart = detailDate.offset(.minute, value: -30)!
            let minEnd = detailDate.offset(.minute, value: 30)!

            // Then slice it to the per-minute basis next
            let nearestMinuteMoonPosition = PlanetsRequest(body: .moon).fetch(start: minStart, end: minEnd, interval: 60.0)
                .min { lhs, rhs in
                    return lhs.longitudeDelta(other: node.longitude) < rhs.longitudeDelta(other: node.longitude)
                }

            guard let nearestMinuteMoonPosition = nearestMinuteMoonPosition else {
                continue
            }

            moonConjunctions[nodeName] = nearestMinuteMoonPosition
        }

        let nearestHourMoonPosition = PlanetsRequest(body: .moon).fetch(start: start, end: end, interval: Double(60 * 60))
            .filter(filterPredicate(other: TottenhamUKTests.chiron, degree: 0.0, orb: 10.0))
            .min { lhs, rhs in
                return lhs.longitudeDelta(other: TottenhamUKTests.chiron.longitude) < rhs.longitudeDelta(other: TottenhamUKTests.chiron.longitude)
            }

        if let nearestHourMoonPosition = nearestHourMoonPosition {
            let detailDate = nearestHourMoonPosition.date
            let minStart = detailDate.offset(.minute, value: -30)!
            let minEnd = detailDate.offset(.minute, value: 30)!

            // Then slice it to the per-minute basis next
            let nearestMinuteMoonPosition = PlanetsRequest(body: .moon).fetch(start: minStart, end: minEnd, interval: 60.0)
                .min { lhs, rhs in
                    return lhs.longitudeDelta(other: TottenhamUKTests.chiron.longitude) < rhs.longitudeDelta(other: TottenhamUKTests.chiron.longitude)
                }

            if let nearestMinuteMoonPosition = nearestMinuteMoonPosition {
                moonConjunctions["Chiron"] = nearestMinuteMoonPosition
            }
        }
        else {
            print("Skipping Chiron")
        }

        // Birthdate: 1988-05-05 02:02:00 UTC
        // Tottenham, England, UK
        print("With a birth chart of 1988-05-05 02:02:00 UTC at Tottenham, England, UK")
        print("From a start time of " + start.toString(format: .cocoaDateTime, timeZone: .utc)! + " + \(daysOut) days...")
        for (bodyName, body) in moonConjunctions {
            print("\(bodyName)\'s closest moon time is \(body.date)")
        }

        XCTAssertTrue(moonConjunctions.count == 6)
    }
}
