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

    func returnSignForRange(_ houses: HouseCusps, _ range: ClosedRange<Double>) -> Sign? {
        if range.contains(houses.aries.value + houses.ascendent.value) {
            return houses.aries
        }
        if range.contains(houses.taurus.value + houses.ascendent.value) {
            return houses.taurus
        }
        if range.contains(houses.gemini.value + houses.ascendent.value) {
            return houses.gemini
        }
        if range.contains(houses.cancer.value + houses.ascendent.value) {
            return houses.cancer
        }
        if range.contains(houses.leo.value + houses.ascendent.value) {
            return houses.leo
        }
        if range.contains(houses.virgo.value + houses.ascendent.value) {
            return houses.virgo
        }
        if range.contains(houses.libra.value + houses.ascendent.value) {
            return houses.libra
        }
        if range.contains(houses.scorpio.value + houses.ascendent.value) {
            return houses.scorpio
        }
        if range.contains(houses.sagittarius.value + houses.ascendent.value) {
            return houses.sagittarius
        }
        if range.contains(houses.capricorn.value + houses.ascendent.value) {
            return houses.capricorn
        }
        if range.contains(houses.aquarius.value + houses.ascendent.value) {
            return houses.aquarius
        }
        if range.contains(houses.pisces.value + houses.ascendent.value) {
            return houses.pisces
        }

        return nil
    }

    func testPrototypeHouseIngresses() throws {
        let houses = ClevelandIngress.houseCusps
        let startDate = Date(fromString: "2022-07-18 07:00:00 -0700", format: .cocoaDateTime, timeZone: .utc)!
        let endDate = startDate.offset(.week, value: 1)!
        let hourSlice = Double(60 * 60)
        let planetCases = Planet.allCases.filter { planet in
            return planet != .moon
        }

        for planet in planetCases {
            let hourPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: hourSlice)
            let hourFirst = hourPositions.first!
            let hourLast = hourPositions.last!

            if hourFirst.longitude > hourLast.longitude {
                print("No retrograde ingresses for \(planet) at this time")
                continue
            }

            var range = hourFirst.longitude ... hourLast.longitude
            let startString = hourFirst.date.toString(format: .cocoaDateTime)!
            let endString = hourLast.date.toString(format: .cocoaDateTime)!
            guard let (house, key) = returnHouseForRange(houses, range) else {
                print("No house ingresses found for \(planet) during date range: \(startString) to \(endString)")
                continue
            }

            let minuteSlice = 60.0
            let minPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: minuteSlice)

            for i in stride(from: 0, to: minPositions.endIndex, by: 1) {
                let minFirst = minPositions[i]
                let minLast = minPositions[i + 1]
                range = minFirst.longitude ... minLast.longitude

                if range.contains(house.value) {
                    print("\(planet) makes ingress with \(key) house at \(minLast.date.toString(format: .cocoaDateTime)!)")
                    break
                }
            }
        }
    }

    func testPrototypeSignIngresses() throws {
        let houses = ClevelandIngress.houseCusps
        let startDate = Date(fromString: "2022-07-18 07:00:00 -0700", format: .cocoaDateTime, timeZone: .utc)!
        let endDate = startDate.offset(.week, value: 1)!
        let hourSlice = Double(60 * 60)
        let planetCases = Planet.allCases.filter { planet in
            return planet != .moon
        }

        for planet in planetCases {
            let hourPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: hourSlice)
            let hourFirst = hourPositions.first!
            let hourLast = hourPositions.last!

            if hourFirst.longitude > hourLast.longitude {
                print("No retrograde ingresses for \(planet) at this time")
                continue
            }

            var range = hourFirst.longitude ... hourLast.longitude
            let startString = hourFirst.date.toString(format: .cocoaDateTime)!
            let endString = hourLast.date.toString(format: .cocoaDateTime)!
            guard let sign = returnSignForRange(houses, range) else {
                print("No sign ingress found for \(planet) during date range: \(startString) to \(endString)")
                continue
            }

            let minuteSlice = 60.0
            let minPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: minuteSlice)
            let usableSignLongitude = sign.value + houses.ascendent.value

            for i in stride(from: 0, to: minPositions.endIndex, by: 1) {
                let minFirst = minPositions[i]
                let minLast = minPositions[i + 1]
                range = minFirst.longitude ... minLast.longitude

                if range.contains(usableSignLongitude) {
                    print("\(planet) makes ingress with \(sign.sign) at \(minLast.date.toString(format: .cocoaDateTime)!)")
                    break
                }
            }
        }
    }

    func testPrototypeHouseIngressesForYear() throws {
        let houses = ClevelandIngress.houseCusps
        let originDate = Date(fromString: "2022-07-17 14:00:00 -0700", format: .cocoaDateTime, timeZone: .utc)!
        let hourSlice = Double(60 * 60)
        let minuteSlice = 60.0
        let planetCases = Planet.allCases.filter { planet in
            return planet != .moon
        }

        for i in stride(from: 0, to: 52, by: 1) {
            let startDate = originDate.offset(.week, value: i)!
            let endDate = startDate.offset(.week, value: 1)!.offset(.hour, value: 1)!

            for planet in planetCases {
                let hourPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: hourSlice)
                let hourFirst = hourPositions.first!
                let hourLast = hourPositions.last!
                let startString = hourFirst.date.toString(format: .cocoaDateTime)!
                let endString = hourLast.date.toString(format: .cocoaDateTime)!

                if hourFirst.longitude > hourLast.longitude {
                    print("No \(planet) retrograde house ingresses during this week: \(startString) to \(endString)")
                    continue
                }

                var range = hourFirst.longitude ... hourLast.longitude
                guard let (house, key) = returnHouseForRange(houses, range) else {
                    print("No house ingresses found for \(planet) during date range: \(startString) to \(endString)")
                    continue
                }

                let minPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: minuteSlice)

                for i in stride(from: 0, to: minPositions.endIndex, by: 1) {
                    let minFirst = minPositions[i]
                    let minLast = minPositions[i + 1]
                    if minLast.longitude <= minFirst.longitude {
//                        let minFirstString = minFirst.date.toString(format: .cocoaDateTime)!
//                        let minLastString = minLast.date.toString(format: .cocoaDateTime)!
//                        print("Punting on \(planet) retrograde starting during this potential period: \(minFirstString) to \(minLastString)")
                        continue
                    }

                    range = minFirst.longitude ... minLast.longitude

                    if range.contains(house.value) {
                        print("\(planet) makes ingress with \(key) house at \(minLast.date.toString(format: .cocoaDateTime)!)")
                        break
                    }
                }
            }
        }
    }

    func testPrototypeSignIngressesForYear() throws {
        let houses = ClevelandIngress.houseCusps
        let originDate = Date(fromString: "2022-07-17 14:00:00 -0700", format: .cocoaDateTime, timeZone: .utc)!
        let hourSlice = Double(60 * 60)
        let minuteSlice = 60.0
        let planetCases = Planet.allCases.filter { planet in
            return planet != .moon
        }

        for i in stride(from: 0, to: 52, by: 1) {
            let startDate = originDate.offset(.week, value: i)!
            let endDate = startDate.offset(.week, value: 1)!.offset(.hour, value: 1)!

            for planet in planetCases {
                let hourPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: hourSlice)
                let hourFirst = hourPositions.first!
                let hourLast = hourPositions.last!
                let startString = hourFirst.date.toString(format: .cocoaDateTime)!
                let endString = hourLast.date.toString(format: .cocoaDateTime)!

                if hourFirst.longitude > hourLast.longitude {
                    print("No \(planet) retrograde sign ingresses during this week: \(startString) to \(endString)")
                    continue
                }

                var range = hourFirst.longitude ... hourLast.longitude
                guard let sign = returnSignForRange(houses, range) else {
                    print("No sign ingress found for \(planet) during date range: \(startString) to \(endString)")
                    continue
                }

                let minPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: minuteSlice)
                let usableSignLongitude = sign.value + houses.ascendent.value

                for i in stride(from: 0, to: minPositions.endIndex, by: 1) {
                    let minFirst = minPositions[i]
                    let minLast = minPositions[i + 1]
                    if minLast.longitude <= minFirst.longitude {
//                        let minFirstString = minFirst.date.toString(format: .cocoaDateTime)!
//                        let minLastString = minLast.date.toString(format: .cocoaDateTime)!
//                        print("Punting on \(planet) retrograde starting during this potential period: \(minFirstString) to \(minLastString)")
                        continue
                    }

                    range = minFirst.longitude ... minLast.longitude

                    if range.contains(usableSignLongitude) {
                        print("\(planet) makes ingress with \(sign.sign) at \(minLast.date.toString(format: .cocoaDateTime)!)")
                        break
                    }
                }
            }
        }
    }
}
