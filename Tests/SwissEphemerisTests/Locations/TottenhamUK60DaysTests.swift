//
//  TottenhamUK60DaysTests.swift
//  
//
//  Created by Sam Krishna on 3/16/22.
//

import XCTest
@testable import SwissEphemeris

class TottenhamUK60DaysTests: XCTestCase {

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
            "North Node" : Coordinate(body: LunarNode.meanNode, date: birthDate),
            "South Node" : Coordinate(body: LunarNode.meanSouthNode, date: birthDate)
        ]
    }

    static var chiron: Coordinate<Asteroid> {
        return Coordinate(body: Asteroid.chiron, date: birthDate)
    }

    func testTottenhamUKConjunctions() throws {
        let daysOut = 60
        let start = TottenhamUK60DaysTests.testStartDate
        let end = start.offset(.day, value: daysOut)!
        var moonConjunctions = [(String, Coordinate<Planet>)]()

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

        var firstHour: Date?
        var endOfDay: Date?

        for (planetName, planet) in TottenhamUK60DaysTests.planets {
            let nearestFilteredHourPositions = BodiesRequest(body: Planet.moon).fetch(start: start, end: end, interval: Double(60 * 60))
                .filter(filterPredicate(other: planet, degree: 0.0, orb: 10.0))

            let coordinatesDict = Dictionary(grouping: nearestFilteredHourPositions) { (coordinate) -> Date in
                if firstHour == nil || coordinate.date > endOfDay! {
                    firstHour = coordinate.date
                    endOfDay = firstHour?.offset(.day, value: 1)
                    return firstHour!
                }

                return firstHour!
            }
            firstHour = nil
            endOfDay = nil

            var nearestHourPositions = [Coordinate<Planet>]()

            for (_, coordinates) in coordinatesDict {
                let nearestPosition = coordinates.min { lhs, rhs in
                    return lhs.longitudeDelta(other: planet) < rhs.longitudeDelta(other: planet)
                }

                nearestHourPositions.append(nearestPosition!)
            }

            for nearestHourPositionByDay in nearestHourPositions {
                let detailDate = nearestHourPositionByDay.date
                let minStart = detailDate.offset(.minute, value: -30)!
                let minEnd = detailDate.offset(.minute, value: 30)!

                // Then slice it to the per-minute basis next
                let nearestMinutePosition = BodiesRequest(body: Planet.moon).fetch(start: minStart, end: minEnd, interval: 60.0)
                    .min { lhs, rhs in
                        return lhs.longitudeDelta(other: planet) < rhs.longitudeDelta(other: planet)
                    }

                guard let nearestMinuteMoonPosition = nearestMinutePosition else {
                    continue
                }

                let tuple = (planetName, nearestMinuteMoonPosition)
                moonConjunctions.append(tuple)
            }
        }

        for (nodeName, node) in TottenhamUK60DaysTests.nodes {
            let nearestFilteredHourPositions = BodiesRequest(body: Planet.moon).fetch(start: start, end: end, interval: Double(60 * 60))
                .filter(filterPredicate(other: node, degree: 0.0, orb: 10.0))

            if nearestFilteredHourPositions.count == 0 {
                print("Skipping \(nodeName)")
                continue
            }

            let coordinatesDict = Dictionary(grouping: nearestFilteredHourPositions) { (coordinate) -> Date in
                if firstHour == nil || coordinate.date > endOfDay! {
                    firstHour = coordinate.date
                    endOfDay = firstHour?.offset(.day, value: 1)
                    return firstHour!
                }

                return firstHour!
            }
            firstHour = nil
            endOfDay = nil

            var nearestHourPositions = [Coordinate<Planet>]()

            for (_, coordinates) in coordinatesDict {
                let nearestPosition = coordinates.min { lhs, rhs in
                    return lhs.longitudeDelta(other: node) < rhs.longitudeDelta(other: node)
                }

                nearestHourPositions.append(nearestPosition!)
            }

            for nearestPosition in nearestHourPositions {
                let detailDate = nearestPosition.date
                let minStart = detailDate.offset(.minute, value: -30)!
                let minEnd = detailDate.offset(.minute, value: 30)!

                // Then slice it to the per-minute basis next
                let nearestMinuteMoonPosition = BodiesRequest(body: Planet.moon).fetch(start: minStart, end: minEnd, interval: 60.0)
                    .min { lhs, rhs in
                        return lhs.longitudeDelta(other: node) < rhs.longitudeDelta(other: node)
                    }

                guard let nearestMinuteMoonPosition = nearestMinuteMoonPosition else {
                    continue
                }

                let tuple = (nodeName, nearestMinuteMoonPosition)
                moonConjunctions.append(tuple)
            }
        }

        let chiron = Coordinate(body: Asteroid.chiron, date: TottenhamUK60DaysTests.birthDate)
        let nearestFilteredHourPositions = BodiesRequest(body: Planet.moon).fetch(start: start, end: end, interval: Double(60 * 60))
            .filter(filterPredicate(other: chiron, degree: 0.0, orb: 10.0))

        let coordinatesDict = Dictionary(grouping: nearestFilteredHourPositions) { (coordinate) -> Date in
            if firstHour == nil || coordinate.date > endOfDay! {
                firstHour = coordinate.date
                endOfDay = firstHour?.offset(.day, value: 1)
                return firstHour!
            }

            return firstHour!
        }
        firstHour = nil
        endOfDay = nil

        var nearestHourPositions = [Coordinate<Planet>]()

        for (_, coordinates) in coordinatesDict {
            let nearestPosition = coordinates.min { lhs, rhs in
                return lhs.longitudeDelta(other: chiron) < rhs.longitudeDelta(other: chiron)
            }

            nearestHourPositions.append(nearestPosition!)
        }

        if nearestHourPositions.count > 0 {
            for nearestHourPositionByDay in nearestHourPositions {
                let detailDate = nearestHourPositionByDay.date
                let minStart = detailDate.offset(.minute, value: -30)!
                let minEnd = detailDate.offset(.minute, value: 30)!

                // Then slice it to the per-minute basis next
                let nearestMinutePosition = BodiesRequest(body: Planet.moon).fetch(start: minStart, end: minEnd, interval: 60.0)
                    .min { lhs, rhs in
                        return lhs.longitudeDelta(other: chiron) < rhs.longitudeDelta(other: chiron)
                    }

                guard let nearestMinuteMoonPosition = nearestMinutePosition else {
                    continue
                }

                let tuple = ("Chiron", nearestMinuteMoonPosition)
                moonConjunctions.append(tuple)
            }
        }
        else {
            print("Skipping Chiron")
        }

        // Birthdate: 1988-05-05 02:02:00 UTC
        // Tottenham, England, UK
        print("With a birth chart of 1988-05-05 02:02:00 UTC at Tottenham, England, UK")
        print("From a start time of " + start.toString(format: .cocoaDateTime, timeZone: .utc)! + " + \(daysOut) days...")

        moonConjunctions.sort { lhs, rhs in
            return lhs.1.date < rhs.1.date
        }

        for (name, coordinate) in moonConjunctions {
            let transit = String("\(name)\'s closest conjunction time to \(coordinate.body) is \(coordinate.date) at longitude: \(Int(coordinate.longitude)) degrees")
            print("\(transit)")
        }
    }
}
