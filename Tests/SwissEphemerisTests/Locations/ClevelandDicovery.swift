//
//  ClevelandDicovery.swift
//  
//
//  Created by Sam Krishna on 3/30/22.
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

extension ClosedRange where Bound : Comparable {
    func intersection(_ other: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        let lower = Swift.max(lowerBound, other.lowerBound)
        let upper = Swift.min(upperBound, other.upperBound)
        guard lower <= upper else {
            return nil
        }

        return lower ... upper
    }
}

extension Range where Bound : Comparable {
    func intersection(_ other: Range<Bound>) -> Range<Bound> {
        let lower = Swift.max(lowerBound, other.lowerBound)
        let upper = Swift.min(upperBound, other.upperBound)
        guard lower <= upper else {
            return other.lowerBound ..< other.lowerBound
        }

        return lower ..< upper
    }
}

class ClevelandDiscovery: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    let conjunction: Double = 1.0
    let trine: Double = 120.0
    let square: Double = 90.0
    let opposition: Double = 180.0
    let sextile: Double = 60.0

    /// Modify `startDate` to have a different testing start date window for lunar transits
    // transits -ab=pluto -da=15 -tat=square -ssd="2022-03-22 19:00:00 -0700"
    static var testStartDate: Date {
        return Date(fromString: "2022-03-22 19:00:00 -0700", format: .cocoaDateTime, timeZone: .utc)!
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
            "North Node" : Coordinate(body: LunarNode.meanNode, date: birthDate),
            "South Node" : Coordinate(body: LunarNode.meanSouthNode, date: birthDate)
        ]
    }

    static var chiron: Coordinate<Asteroid> {
        return Coordinate(body: Asteroid.chiron, date: birthDate)
    }

    func testNeptuneAndJupiterConjunction() throws {
        let start = Date(fromString: "2022-04-01 00:00:00 -0700", format: .cocoaDateTime)!
        let end = Date(fromString: "2022-04-30 23:59:59 -0700", format: .cocoaDateTime)!
        let daySlice = Double(24 * 60 * 60)

        func filterPredicate<First, Second>(other: Coordinate<Second>, degree: Double, orb: Double) -> (Coordinate<First>) -> Bool {
            return { (first) in
                let degreeRange = (degree - orb) ... (degree + orb)
                return degreeRange.contains(first.longitudeDelta(other: other))
            }
        }

        let jupiterCoords = BodiesRequest(body: Planet.jupiter).fetch(start: start, end: end, interval: daySlice)
        let neptuneCoords = BodiesRequest(body: Planet.neptune).fetch(start: start, end: end, interval: daySlice)

        let jupiterRange = jupiterCoords.first!.longitude ... jupiterCoords.last!.longitude
        let neptuneRange = neptuneCoords.first!.longitude ... neptuneCoords.last!.longitude
        let intersectedRange = jupiterRange.intersection(neptuneRange)
        print("intersection = \(intersectedRange!.lowerBound) to \(intersectedRange!.upperBound)")
        var indexSet: IndexSet = IndexSet()

        for (jIndex, jc) in jupiterCoords.enumerated() {
            let nc = neptuneCoords[jIndex]
            let jDegreeRange = -2.0 ... 2.0
            let delta = jc.longitudeDelta(other: nc)
            if jDegreeRange.contains(delta) {
                indexSet.insert(jIndex)
            }
        }

        let jcs = indexSet.map {
            jupiterCoords[$0]
        }

        let ncs = indexSet.map {
            neptuneCoords[$0]
        }

        func roundLongitude(_ body: Coordinate<Planet>) -> Double {
            let rlong = round(body.longitude * 100) / 100.0
            return rlong
        }

        let jcFirst = jcs.first!
        let jcFirstDate = jcFirst.date.toString(format: .cocoaDateTime)!
        let jcFirstLong = roundLongitude(jcFirst)
        let jcLast = jcs.last!
        let jcLastDate = jcLast.date.toString(format: .cocoaDateTime)!
        let jcLastLong = roundLongitude(jcLast)

        let ncFirst = ncs.first!
        let ncFirstDate = ncFirst.date.toString(format: .cocoaDateTime)!
        let ncFirstLong = roundLongitude(ncFirst)
        let ncLast = ncs.last!
        let ncLastDate = ncLast.date.toString(format: .cocoaDateTime)!
        let ncLastLong = roundLongitude(ncLast)

        print("Jupiter conjunction of Neptune at:")
        print("Jupiter starts at \(jcFirstDate) at long: \(jcFirstLong)")
        print("Neptune starts at \(ncFirstDate) at long: \(ncFirstLong)")
        print("Jupiter ends at \(jcLastDate) at long: \(jcLastLong)")
        print("Neptune ends at \(ncLastDate) at long: \(ncLastLong)")


//        start = jcFirst.date.offset(.day, value: -1)!
//        end = jcFirst.date.offset(.day, value: 1)!
//
//        jupiterCoords = BodiesRequest(body: Planet.jupiter).fetch(start: start, end: end, interval: 60.0)
//        neptuneCoords = BodiesRequest(body: Planet.neptune).fetch(start: start, end: end, interval: 60.0)
//
//        var minIndex: Int
//        for (jIndex, jc) in jupiterCoords.enumerated() {
//            let nc = neptuneCoords[jIndex]
//            let jDegreeRange = -2.0 ... 2.0
//            var delta = jc.longitudeDelta(other: nc)
//
//        }

    }

    // transits -ab=pluto -da=15 -tat=square -ssd="2022-03-22 19:00:00 -0700"
    func testClevelandDiscoverySquares() throws {
        let daysOut = 15
        let start = ClevelandDiscovery.testStartDate
        let end = start.offset(.day, value: daysOut)!
        let moonConjunctions = [String : Coordinate<Planet>]()

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
                let degreeRange = (degree - orb) ... (degree + orb)
                return degreeRange.contains(first.longitudeDelta(other: other))
            }
        }

        // transits -ab=pluto -da=15 -tat=square -ssd="2022-03-22 19:00:00 -0700"

        let body = Planet.pluto
        let degree = 90.0
        let orb = 2.0
        let daySlice = Double(24 * 60 * 60)
        let hourSlice = Double(60 * 60)
        let minuteSlice = 60.0
        let planet = Coordinate(body: Planet.pluto, date: ClevelandDiscovery.birthDate)

        let nearestPositions = BodiesRequest(body: body).fetch(start: start, end: end, interval: daySlice)
            .filter(filterPredicate(other: planet, degree: degree, orb: orb))
        if nearestPositions.count > 0 {
            for position in nearestPositions {
                let liveLongitude = round(position.longitude * 100) / 100.0
                let natalLongitude = round(planet.longitude * 100) / 100.0
                print("live position = \(liveLongitude) and natal position = \(natalLongitude) and date = \(position.date)")
            }
        }

        let nearestDayPosition = BodiesRequest(body: body).fetch(start: start, end: end, interval: daySlice)
            .filter(filterPredicate(other: planet, degree: degree, orb: orb))
            .min { lhs, rhs in
                return lhs.longitudeDelta(other: planet) < rhs.longitudeDelta(other: planet)
            }

        guard let nearestDayPosition = nearestDayPosition else {
            print("Skipping")
            return
        }

        let yearBefore = nearestDayPosition.date.offset(.year, value: -1)!
        let yearAfter = nearestDayPosition.date.offset(.year, value: 1)!
        let orbPositions = BodiesRequest(body: body).fetch(start: yearBefore, end: yearAfter, interval: daySlice)
            .filter(filterPredicate(other: planet, degree: degree, orb: orb))

        if orbPositions.count == 0 {
            print("skipping")
            return
        }

        print("first position day = \(orbPositions.first!.date)")
        print("last position day = \(orbPositions.last!.date)")


        let dayDetailDate = nearestDayPosition.date
        let hourStart = dayDetailDate.offset(.hour, value: -12)!
        let hourend = dayDetailDate.offset(.hour, value: 12)!
        let nearestHourPosition = BodiesRequest(body: body).fetch(start: hourStart, end: hourend, interval: hourSlice)
            .filter(filterPredicate(other: planet, degree: degree, orb: orb))
            .min { lhs, rhs in
                return lhs.longitudeDelta(other: planet) < rhs.longitudeDelta(other: planet)
            }

        guard let nearestHourPosition = nearestHourPosition else {
            print("Skipping")
            return
        }

        let detailDate = nearestHourPosition.date
        let minStart = detailDate.offset(.minute, value: -30)!
        let minEnd = detailDate.offset(.minute, value: 30)!

        // Then slice it to the per-minute basis next
        let _ = BodiesRequest(body: Planet.moon).fetch(start: minStart, end: minEnd, interval: minuteSlice)
            .min { lhs, rhs in
                return lhs.longitudeDelta(other: planet) < rhs.longitudeDelta(other: planet)
            }

        print("With a birth chart of \(ClevelandDiscovery.birthDate) at Cleveland, OH, USA")
        print("From a start time of " + start.toString(format: .cocoaDateTime, timeZone: .utc)! + " + \(daysOut) days...")
        for (bodyName, body) in moonConjunctions {
            print("\(bodyName)\'s closest moon time is \(body.date)")
        }

        XCTAssertTrue(moonConjunctions.count == 0)
    }
}
