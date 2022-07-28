//
//  ClevelandIngress.swift
//  
//
//  Created by Sam Krishna on 7/27/22.
//

import XCTest
@testable import SwissEphemeris

class ClevelandIngress: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        let dob = "1983-03-17 09:45:00 -0500"
        let dobDate = Date(fromString: dob, format: .cocoaDateTime)!
        return dobDate
    }

    static var houseCusps: HouseCusps {
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

    func returnHouseForRange(_ houses: HouseCusps, _ range: ClosedRange<Double>) -> (Cusp, String)? {
        if range.contains(houses.first.value) {
            return (houses.first, "1st")
        }
        if range.contains(houses.second.value) {
            return (houses.second, "2nd")
        }
        if range.contains(houses.third.value) {
            return (houses.third, "3rd")
        }
        if range.contains(houses.fourth.value) {
            return (houses.fourth, "4th")
        }
        if range.contains(houses.fifth.value) {
            return (houses.fifth, "5th")
        }
        if range.contains(houses.sixth.value) {
            return (houses.sixth, "6th")
        }
        if range.contains(houses.seventh.value) {
            return (houses.seventh, "7th")
        }
        if range.contains(houses.eighth.value) {
            return (houses.eighth, "eighth")
        }
        if range.contains(houses.ninth.value) {
            return (houses.ninth, "ninth")
        }
        if range.contains(houses.tenth.value) {
            return (houses.tenth, "tenth")
        }
        if range.contains(houses.eleventh.value) {
            return (houses.eleventh, "eleventh")
        }
        if range.contains(houses.twelfth.value) {
            return (houses.twelfth, "twelfth")
        }

        return nil
    }
        let houses = ClevelandIngress.houseCusps
        let startDate = Date(fromString: "2022-07-18 07:00:00 -0700", format: .cocoaDateTime, timeZone: .utc)!
        let endDate = startDate.offset(.day, value: 7)!
        let hourSlice = Double(60 * 60)

        for planet in Planet.allCases {
            let positions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: hourSlice)
            let posFirst = positions.first!
            let posLast = positions.last!

            if posFirst.longitude > posLast.longitude {
                print("No retrograde ingresses for \(planet) at this time")
                continue
            }

            let range = posFirst.longitude ... posLast.longitude
            guard let (_, key) = returnHouseForRange(range) else {
                print("No house ingress found for \(planet)")
                continue
            }

            print("\(planet) makes ingress with house = \(key)")
        }


            return nil
        }

        func filterPredicate<First, Second>(other: Coordinate<Second>, degree: Double, orb: Double) -> (Coordinate<First>) -> Bool {
            return { (first) in
                let degreeRange = (degree - orb) ... (degree + orb)
                if degreeRange.contains(first.longitudeDelta(other: other)) { return true }
                let degreeRange2 = (degree + 360.0 - orb) ... (degree + 360.0 + orb)
                return degreeRange2.contains(first.longitudeDelta(other: other))
            }
        }

    }

}
