//
//  MercuryIngress.swift
//  
//
//  Created by Sam Krishna on 8/21/22.
//

import XCTest
@testable import SwissEphemeris

class MercuryIngress: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
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

    // Zodiac sign transits
    // Pluto takes between 12-31 years to transit a sign
    // Neptune: 14 years
    // Uranus: 7 years
    // Saturn: 2 1/2 years
    // Jupiter: 1 year
    // Mars: 2-7 months
    // Venus: 23 days to 2 months
    // Mercury: 15-60 days


    func testMercuryEgressVirgo() throws {
        let planet = Planet.mercury
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(signTuple.dateType, value: signTuple.amount)!

        func sliceTimeForEgress(_ start: Date, _ stop: Date, _ timeSlice: Double) -> (egress: Coordinate<Planet>, ingress: Coordinate<Planet>)? {
            let positions = BodiesRequest(body: planet).fetch(start: start, end: stop, interval: timeSlice)

            return zip(positions, positions.dropFirst())
                .first { (now, later) in now.sign != later.sign }
                .map { (now, later) in (now, later) }
        }

        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        let sliceIndex = signTuple.dateType == .month ? 0 : 1
        var start = originDate
        var end = endDate
        var ingressTuple: (egress: Coordinate<Planet>, ingress: Coordinate<Planet>)?

        for i in stride(from: sliceIndex, to: slices.endIndex, by: 1) {
            let time = slices[i]
            ingressTuple = sliceTimeForEgress(start, end, time.slice)

            guard let ingressTuple = ingressTuple else {
                XCTFail("We have a failure for a given time slice: \(time)")
                return
            }

            start = ingressTuple.egress.date
            end = ingressTuple.ingress.date
        }

        guard let tuple = ingressTuple else { return }

        // mercury egresses virgo at 2022-08-25 18:02:00 -0700
        // mercury ingresses libra at 2022-08-25 18:03:00 -0700
        let egressDate = Date(fromString: "2022-08-25 18:02:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-08-25 18:03:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.virgo)
        XCTAssert(tuple.ingress.sign == Zodiac.libra)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(tuple.egress.sign) at \(beforeString)")
        print("\(planet) ingresses \(tuple.ingress.sign) at \(afterString)")
    }

    func testMercuryIngressVirgo() throws {
        let planet = Planet.mercury
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let priorDate = originDate.offset(signTuple.dateType, value: (-1 * signTuple.amount))!
        func sliceTimeForIngress(_ start: Date, _ stop: Date, _ timeSlice: Double) -> (egress: Coordinate<Planet>, ingress: Coordinate<Planet>)? {
            let positions = BodiesRequest(body: planet).fetch(start: start, end: stop, interval: timeSlice)

            return Array(zip(positions, positions.dropFirst()))
                .last { (now, later) in now.sign != later.sign }
                .map { (now, later) in (now, later) }
        }

        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        let sliceIndex = signTuple.dateType == .month ? 0 : 1
        var start = priorDate
        var end = originDate
        var ingressTuple: (egress: Coordinate<Planet>, ingress: Coordinate<Planet>)?

        for i in stride(from: sliceIndex, to: slices.endIndex, by: 1) {
            let time = slices[i]
            ingressTuple = sliceTimeForIngress(start, end, time.slice)

            guard let ingressTuple = ingressTuple else {
                XCTFail("We have a failure for a given time slice: \(time)")
                return
            }

            start = ingressTuple.egress.date
            end = ingressTuple.ingress.date
        }

        guard let tuple = ingressTuple else { return }

        // mercury egresses virgo at 2022-08-03 23:57:00 -0700
        // mercury ingresses leo at 2022-08-03 23:58:00 -0700
        let egressDate = Date(fromString: "2022-08-03 23:57:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-08-03 23:58:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.leo)
        XCTAssert(tuple.ingress.sign == Zodiac.virgo)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(tuple.egress.sign) at \(beforeString)")
        print("\(planet) ingresses \(tuple.ingress.sign) at \(afterString)")
    }

    func testMercuryIngressHouses() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.mercury
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(signTuple.dateType, value: signTuple.amount)!
        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        let sliceIndex = signTuple.dateType == .month ? 0 : 1
        let time = slices[sliceIndex]
        let positions = BodiesRequest(body: planet).fetch(start: originDate, end: endDate, interval: time.slice)

        // Find house of Mercury at start date:
        let pos0 = positions.first!
        let offsetHouses = Array(chart.houses.dropFirst()) + [chart.first]
        let pair: (ingress: Cusp, egress: Cusp)

        for (current, next) in zip(chart.houses, offsetHouses) {
            if current.value <= pos0.longitude && pos0.longitude < next.value {
                pair = (current, next)
                break
            }
        }

        
    }
}
