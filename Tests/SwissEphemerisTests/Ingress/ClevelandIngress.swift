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
        let minuteSlice = 60.0
        let planetCases = Planet.allCases.filter { planet in
            return planet != .moon
        }

        for planet in planetCases {
            let hourPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: hourSlice)
            let hourFirst = hourPositions.first!
            let hourLast = hourPositions.last!
            let startString = hourFirst.date.toString(format: .cocoaDateTime)!
            let endString = hourLast.date.toString(format: .cocoaDateTime)!

            if hourFirst.longitude > hourLast.longitude {
                let retroHourRange = hourLast.longitude ... hourFirst.longitude
                guard let (house, key) = returnHouseForRange(houses, retroHourRange) else {
                    print("No house ingresses found for \(planet) retrograde during date range: \(startString) to \(endString)")
                    continue
                }

                let minPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: minuteSlice)
                for i in stride(from: minPositions.endIndex - 1, to: 0, by: -1) {
                    let minFirst = minPositions[i]
                    let minLast = minPositions[i - 1]
                    let retroMinRange = minFirst.longitude < minLast.longitude ? minFirst.longitude ... minLast.longitude : minLast.longitude ... minFirst.longitude

                    if retroMinRange.contains(house.value) {
                        print("\(planet) retrograde makes ingress with \(key) house at \(minLast.date.toString(format: .cocoaDateTime)!)")
                        break
                    }
                }

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
        let bdString = houses.date.toString(format: .cocoaDateTime)!
        print("House birthdate: \(bdString) at lat: \(houses.latitude) long: \(houses.longitude)\n")

        let originDate = Date(fromString: "2022-07-17 14:00:00 -0700", format: .cocoaDateTime, timeZone: .utc)!
        let hourSlice = Double(60 * 60)
        let minuteSlice = 60.0
        let planetCases = Planet.allCases.filter { planet in
            return planet != .moon
        }

        for i in stride(from: 0, to: 52, by: 1) {
            let startDate = originDate.offset(.week, value: i)!
            let endDate = startDate.offset(.week, value: 1)!.offset(.hour, value: 1)!
            let sdString = startDate.toString(format: .cocoaDateTime)!
            let edString = endDate.offset(.hour, value: -1)!.toString(format: .cocoaDateTime)!
            print("House ingresses for week between \(sdString) and \(edString)")

            for planet in planetCases {
                let hourPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: hourSlice)
                let hourFirst = hourPositions.first!
                let hourLast = hourPositions.last!

                if hourFirst.longitude > hourLast.longitude {
                    let retroHourRange = hourLast.longitude ... hourFirst.longitude
                    guard let (house, key) = returnHouseForRange(houses, retroHourRange) else {
                        print("No house ingresses found for \(planet) ~~retrograde~~")
                        continue
                    }

                    let minPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: minuteSlice)
                    for i in stride(from: minPositions.endIndex - 1, to: 0, by: -1) {
                        let minLast = minPositions[i]
                        let minFirst = minPositions[i - 1]
                        let retroMinRange = minLast.longitude < minFirst.longitude ? minLast.longitude ... minFirst.longitude : minFirst.longitude ... minLast.longitude

                        if retroMinRange.contains(house.value) {
                            print("\(planet) ~~retrograde~~ makes ingress with \(key) house at \(minFirst.date.toString(format: .cocoaDateTime)!)")
                            break
                        }
                    }

                    continue
                }

                var range = hourFirst.longitude ... hourLast.longitude
                guard let (house, houseKey) = returnHouseForRange(houses, range) else {
                    print("No house ingresses found for \(planet)") //" during date range: \(startString) to \(endString)")
                    continue
                }

                let minPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: minuteSlice)

                for i in stride(from: 0, to: minPositions.endIndex, by: 1) {
                    let minFirst = minPositions[i]
                    let minLast = minPositions[i + 1]
                    if minLast.longitude < minFirst.longitude { continue }
                    range = minFirst.longitude ... minLast.longitude

                    if range.contains(house.value) {
                        print("\(planet) makes ingress with \(houseKey) house at \(minLast.date.toString(format: .cocoaDateTime)!)")
                        break
                    }
                }
            }
            print("")
        }
    }

    func findRetrogradeTimeRangeForCoordinates<BodyType>(_ coordinates: [Coordinate<BodyType>]) -> (start: Date, end: Date)? where BodyType: CelestialBody {
        if coordinates.count < 3 {
            return nil;
        }

        var dates = [Date]()

        for i in stride(from: 1, to: coordinates.endIndex - 1, by: 1) {
            let prevCoordinate = coordinates[i - 1]
            let thisCoordinate = coordinates[i]
            let nextCoordinate = coordinates[i + 1]
            let preCrossPrimeRange = 359.0 ... 360.0
            let postCrossPrimeRange = 0.0 ... 1.0

            if thisCoordinate.longitude < prevCoordinate.longitude {
                dates.append(prevCoordinate.date)

                if i == coordinates.endIndex - 2 {
                    dates.append(thisCoordinate.date)
                    dates.append(nextCoordinate.date)
                }

                continue
            }

            if preCrossPrimeRange.contains(thisCoordinate.longitude) && postCrossPrimeRange.contains(prevCoordinate.longitude) {
                dates.append(prevCoordinate.date)

                if i == coordinates.endIndex - 2 {
                    dates.append(thisCoordinate.date)
                    dates.append(nextCoordinate.date)
                }

                continue
            }
        }

        if dates.count >= 2 {
            let tuple = (dates.first!, dates.last!)
            return tuple
        }

        return nil
    }

    func findNormalTimeRangeForCoordinates<BodyType>(_ coordinates: [Coordinate<BodyType>]) -> (start: Date, end: Date)? where BodyType: CelestialBody {
        if coordinates.count < 3 {
            return nil;
        }

        var dates = [Date]()

        for i in stride(from: 1, to: coordinates.endIndex - 1, by: 1) {
            let prevCoordinate = coordinates[i - 1]
            let thisCoordinate = coordinates[i]
            let nextCoordinate = coordinates[i + 1]
            let roundedPrev = preciseRound(prevCoordinate.longitude, precision: .thousandths)
            let roundedThis = preciseRound(thisCoordinate.longitude, precision: .thousandths)
            let dateString = thisCoordinate.date.toString(format: .cocoaDateTime, timeZone: .local)!
            let preCrossPrimeRange = 359.0 ... 360.0
            let postCrossPrimeRange = 0.0 ... 1.0

            if thisCoordinate.longitude > prevCoordinate.longitude {
                print("\(dateString) normal motion: thisCoordinate = \(roundedThis) | prevCoordinate = \(roundedPrev)")
                dates.append(prevCoordinate.date)

                if i == coordinates.endIndex - 2 {
                    dates.append(thisCoordinate.date)
                    dates.append(nextCoordinate.date)
                }

                continue
            }

            if postCrossPrimeRange.contains(thisCoordinate.longitude) && preCrossPrimeRange.contains(prevCoordinate.longitude) {
                print("\(dateString) normal motion crosses Prime Meridian: thisCoordinate = \(roundedThis) | prevCoordinate = \(roundedPrev)")
                dates.append(prevCoordinate.date)
                continue
            }
        }

        if dates.count >= 2 {
            let tuple = (dates.first!, dates.last!)
            return tuple
        }

        return nil
    }

    func testPrototypeRetrogradeRangeDiscovery() throws {
        let start = Date(fromString: "2022-10-23 14:00:00 -0700", format: .cocoaDateTime)!
        let end = start.offset(.week, value: 1)!
        let hourSlice = Double(60 * 60)
        let hourPositions = BodiesRequest(body: Planet.jupiter).fetch(start: start, end: end, interval: hourSlice)

        guard let retroTuple = findRetrogradeTimeRangeForCoordinates(hourPositions) else {
            XCTFail("No retrograde tuple found when one was expected")
            return
        }

        let startTest = Date(fromString: "2022-10-23 14:00:00 -0700", format: .cocoaDateTime, timeZone: .utc)!
        let endTest = Date(fromString: "2022-10-30 14:00:00 -0700", format: .cocoaDateTime, timeZone: .utc)!

        XCTAssert(retroTuple.start == startTest)
        XCTAssert(retroTuple.end == endTest)

        let startString = retroTuple.start.toString(format: .cocoaDateTime, timeZone: .local)!
        let endString = retroTuple.end.toString(format: .cocoaDateTime, timeZone: .local)!
        print("retrograde start: \(startString) and end: \(endString)")

        // Find Jupiter retrograde ingress for Pisces
        let houses = ClevelandIngress.houseCusps
        let minSlice = 60.0
        let minPositions = BodiesRequest(body: Planet.jupiter).fetch(start: retroTuple.start, end: retroTuple.end, interval: minSlice)
        let pisces = houses.pisces.value + houses.ascendent.value + 30.0
        let roundedPisces = preciseRound(pisces, precision: .ones)
        let prePMRetroCrossRange = 0.0 ... 1.0
        let postPMRetroCrossRange = 359.0 ... 360.0

        for i in stride(from: 0, to: minPositions.endIndex - 1, by: 1) {
            let thisMin = minPositions[i]
            let nextMin = minPositions[i + 1]
            let nextMinString = nextMin.date.toString(format: .cocoaDateTime, timeZone: .local)!

            if prePMRetroCrossRange.contains(thisMin.longitude) && postPMRetroCrossRange.contains(nextMin.longitude) {
                if postPMRetroCrossRange.contains(roundedPisces) {
                    print("Discovered pisces ingress at \(nextMinString)")
                    break
                }
                else {
                    continue
                }
            }

            let retroMinRange = nextMin.longitude ... thisMin.longitude

            if retroMinRange.contains(pisces) {
                print("Discovered pisces ingress at \(nextMinString)")
                break
            }
        }
    }

    func testPrototypeSignIngressesForYear() throws {
        let houses = ClevelandIngress.houseCusps
        let bdString = houses.date.toString(format: .cocoaDateTime)!
        print("House birthdate: \(bdString) at lat: \(houses.latitude) long: \(houses.longitude)\n")

        let originDate = Date(fromString: "2022-07-17 14:00:00 -0700", format: .cocoaDateTime, timeZone: .utc)!
        let hourSlice = Double(60 * 60)
        let minuteSlice = Double(60)
        let planetCases = Planet.allCases.filter { planet in
            return planet != .moon
        }

        for i in stride(from: 0, to: 52, by: 1) {
            let startDate = originDate.offset(.week, value: i)!
            let endDate = startDate.offset(.week, value: 1)!.offset(.hour, value: 1)!
            let sdString = startDate.toString(format: .cocoaDateTime)!
            let edString = endDate.offset(.hour, value: -1)!.toString(format: .cocoaDateTime)!
            print("Sign ingresses for week between \(sdString) and \(edString)")

            for planet in planetCases {
                let hourPositions = BodiesRequest(body: planet).fetch(start: startDate, end: endDate, interval: hourSlice)
                let hourFirst = hourPositions.first!
                let hourLast = hourPositions.last!

                guard let protoTuple = findNormalTimeRangeForCoordinates(hourPositions) else {
                    guard let retroTuple = findRetrogradeTimeRangeForCoordinates(hourPositions) else {
                        continue
                    }

                    // Find the CURRENT SIGN of the hourLast.longitude
                    // Find the CURRENT SIGN of the hourFirst.longitude
                    // if the two "CURRENT SIGNS" are different, than look for the minute
                    // of the retrograde planetary motion crossing the sign boundary

                    continue
                }

                // Find the CURRENT SIGN of the hourLast.longitude
                // Find the CURRENT SIGN of the hourFirst.longitude
                // if the two "CURRENT SIGNS" are different, than look for the minute
                // of the normal planetary motion crossing the sign boundary

            }
            print("")
        }
    }

    func testSignIngressForWeekEnding20220724() throws {
        let houses = ClevelandIngress.houseCusps
        let leoValue = houses.ascendent.value + houses.leo.value
        var preIngress = Date(fromString: "2022-07-22 13:07:00 -0700", format: .cocoaDateTime)!
        var postIngress = preIngress.offset(.minute, value: 1)!

        let preIngressSun = Coordinate(body: Planet.sun, date: preIngress)
        let postIngressSun = Coordinate(body: Planet.sun, date: postIngress)
        XCTAssert(preIngressSun.longitude < leoValue)
        XCTAssert(postIngressSun.longitude > leoValue)

        preIngress = Date(fromString: "2022-07-19 05:35:00 -0700", format: .cocoaDateTime)!
        postIngress = preIngress.offset(.minute, value: 1)!
        let preIngressMercury = Coordinate(body: Planet.mercury, date: preIngress)
        let postIngressMercury = Coordinate(body: Planet.mercury, date: postIngress)
        XCTAssert(preIngressMercury.longitude < leoValue)
        XCTAssert(postIngressMercury.longitude > leoValue)

        let cancerValue = houses.ascendent.value + houses.cancer.value
        preIngress = Date(fromString: "2022-07-17 18:32:00 -0700", format: .cocoaDateTime)!
        postIngress = preIngress.offset(.minute, value: 1)!
        let preIngressVenus = Coordinate(body: Planet.venus, date: preIngress)
        let postIngressVenus = Coordinate(body: Planet.venus, date: postIngress)
        XCTAssert(preIngressVenus.longitude < cancerValue)
        XCTAssert(postIngressVenus.longitude > cancerValue)
    }

    func testLibraIngressWithMercuryRetrograde() throws {
        let houses = ClevelandIngress.houseCusps
        let libraValue = houses.ascendent.value + houses.libra.value
        let preIngress = Date(fromString: "2022-09-23 05:04:00 -0700", format: .cocoaDateTime)!
        let postIngress = preIngress.offset(.minute, value: 1)!
        let preIngressMercuryRetro = Coordinate(body: Planet.mercury, date: preIngress)
        let postIngressMercuryRetro = Coordinate(body: Planet.mercury, date: postIngress)
        XCTAssert(preIngressMercuryRetro.longitude > libraValue)
        XCTAssert(postIngressMercuryRetro.longitude < libraValue)
    }

    func testHouseIngressesForWeekEnding20220807() throws {
        let houses = ClevelandIngress.houseCusps
        let fourth = houses.fourth.value
        var preIngress = Date(fromString: "2022-08-03 18:52:00 -0700", format: .cocoaDateTime)!
        var postIngress = preIngress.offset(.minute, value: 1)!

        let preIngressSun = Coordinate(body: Planet.sun, date: preIngress)
        let postIngressSun = Coordinate(body: Planet.sun, date: postIngress)
        XCTAssert(preIngressSun.longitude < fourth)
        XCTAssert(postIngressSun.longitude > fourth)

        preIngress = Date(fromString: "2022-08-02 21:40:00 -0700", format: .cocoaDateTime)!
        postIngress = preIngress.offset(.minute, value: 1)!
        let third = houses.third.value
        let preIngressVenus = Coordinate(body: Planet.venus, date: preIngress)
        let postIngressVenus = Coordinate(body: Planet.venus, date: postIngress)
        XCTAssert(preIngressVenus.longitude < third)
        XCTAssert(postIngressVenus.longitude > third)
    }

    func testHouseIngressForNOTVenusRetrograde() throws {
        let houses = ClevelandIngress.houseCusps
        let first = houses.first.value - houses.ascendent.value
        let preIngress = Date(fromString: "2023-02-19 23:55:00 -0800", format: .cocoaDateTime)!
        let postIngress = preIngress.offset(.minute, value: 1)!
        let preIngressVenusRetrograde = Coordinate(body: Planet.venus, date: preIngress)
        let postIngressVenusRetrograde = Coordinate(body: Planet.venus, date: postIngress)

        // Try a variation of this idea:
        // https://stackoverflow.com/a/5552247/14173138
        let preLongitude = preIngressVenusRetrograde.longitude > 180.0 ? preIngressVenusRetrograde.longitude - 360.0 : preIngressVenusRetrograde.longitude
        let postLongitude = postIngressVenusRetrograde.longitude > 180.0 ? postIngressVenusRetrograde.longitude - 360.0 : postIngressVenusRetrograde.longitude
        let longitudeRange = preLongitude < postLongitude ? preLongitude ... postLongitude : postLongitude ... preLongitude

        if postLongitude < preLongitude {
            print("RETROGRADE!")
        }

        XCTAssert(longitudeRange.contains(first))
    }
}
