//
//  PlutoIngress.swift
//  
//
//  Created by Sam Krishna on 8/20/22.
//

import XCTest
@testable import SwissEphemeris

class PlutoIngress: XCTestCase {

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

    static var signTransits: [Planet : (dateType: Date.DateComponentType, amount: Int)] {
        let d: [Planet : (dateType: Date.DateComponentType, amount: Int)] = [
            .sun : (.day, 35),
            .mercury : (.day, 65),
            .venus : (.day, 70),
            .mars : (.month, 8),
            .jupiter : (.month, 13),
            .saturn : (.month, Int(2.6 * 12)),
            .uranus : (.month, Int(8 * 12)),
            .neptune : (.month, Int(15 * 12)),
            .pluto : (.month, Int(32 * 12))
        ]

        return d
    }

    // Crazy example of Pluto-in-Capricorn ingress
    // The Pluto in Capricorn-Aquarius Transition
    // January 27th 2008 Pluto enters Capricorn for the first time in 248 years.
    // June 15th 2008 Pluto goes back into Sagittarius.
    // November 27th 2008 Pluto re-enters Capricorn.
    // March 24th 2023 Pluto enters Aquarius.
    // June 12th 2023 Pluto re-enters Capricorn.
    // January 22nd 2024 Pluto enters Aquarius
    // September 3rd 2024 Pluto re-enters Capricorn.
    // November 20th 2024 Pluto enters Aquarius.
    // March 10th 2043 Pluto enters Pisces.
    // September 2nd 2043 Pluto re-enters Aquarius
    // January 20th 2044 Pluto re-enters Pisces.

    // Focus on THIS particular Ingress:
    // November 27th 2008 Pluto re-enters Capricorn.
    // March 24th 2023 Pluto enters Aquarius.


    func testPlutoEgressCapricorn() throws {
        let planet = Planet.pluto
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(signTuple.dateType, value: signTuple.amount)!

        func sliceTimeForIngress(_ start: Date, _ stop: Date, _ timeSlice: Double) -> (egress: Coordinate<Planet>, ingress: Coordinate<Planet>)? {
            let positions = BodiesRequest(body: planet).fetch(start: start, end: stop, interval: timeSlice)

            return zip(positions, positions.dropFirst())
                .first { (now, later) in now.sign != later.sign }
                .map { (now, later) in (now, later) }
        }

        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        let sliceIndex = signTuple.dateType == .month ? 0 : 1
        var start = originDate
        var end = endDate
        var ingressuple: (egress: Coordinate<Planet>, ingress: Coordinate<Planet>)?

        for i in stride(from: sliceIndex, to: slices.endIndex, by: 1) {
            let time = slices[i]
            ingressuple = sliceTimeForIngress(start, end, time.slice)

            guard let ingressTuple = ingressuple else {
                XCTFail("We have a failure for a given time slice: \(time)")
                return
            }

            start = ingressTuple.egress.date
            end = ingressTuple.ingress.date
        }

        guard let tuple = ingressuple else { return }

        // Pluto egresses capricorn at 2023-03-23 05:23:00 -0700
        // Pluto ingresses aquarius at 2023-03-23 05:24:00 -0700
        let egressDate = Date(fromString: "2023-03-23 05:23:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2023-03-23 05:24:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.capricorn)
        XCTAssert(tuple.ingress.sign == Zodiac.aquarius)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("Pluto egresses \(tuple.egress.sign) at \(beforeString)")
        print("Pluto ingresses \(tuple.ingress.sign) at \(afterString)")
    }

    func testPlutoIngressCapricorn() throws {
        let planetBody = Planet.pluto
        guard let tuple = PlutoIngress.signTransits[planetBody] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let priorDate = originDate.offset(tuple.dateType, value: (-1 * tuple.amount))!
        let monthSlice = Double(28 * 24 * 3600)
        let hourSlice = Double(3600)
        let minuteSlice = Double(60)
        let timeSlice = tuple.dateType == .month ? monthSlice : hourSlice
        var positions = BodiesRequest(body: planetBody).fetch(start: priorDate, end: originDate, interval: timeSlice)
        var monthPast: Coordinate<Planet>?
        var monthFuture: Coordinate<Planet>?

        for i in stride(from: positions.endIndex - 1, to: 1, by: -1) {
            let monthNow = positions[i]
            let monthBefore = positions[i - 1]

            if monthNow.sign != monthBefore.sign {
                monthFuture = monthNow
                monthPast = monthBefore
                break
            }
        }

        guard let monthPast = monthPast else { return }
        guard let monthFuture = monthFuture else { return }

        positions = BodiesRequest(body: planetBody).fetch(start: monthPast.date, end: monthFuture.date, interval: hourSlice)

        var hourPast: Coordinate<Planet>?
        var hourFuture: Coordinate<Planet>?

        for i in stride(from: positions.endIndex - 1, to: 1, by: -1) {
            let hourNow = positions[i]
            let hourBefore = positions[i - 1]
            if hourNow.sign != hourBefore.sign {
                hourFuture = hourNow
                hourPast = hourBefore
                break
            }
        }

        guard let hourPast = hourPast else { return }
        guard let hourFuture = hourFuture else { return }

        positions = BodiesRequest(body: planetBody).fetch(start: hourPast.date, end: hourFuture.date, interval: minuteSlice)
        var minutePast: Coordinate<Planet>?
        var minuteFuture: Coordinate<Planet>?

        for i in stride(from: positions.endIndex - 1, to: 1, by: -1) {
            let minuteNow = positions[i]
            let minuteBefore = positions[i - 1]
            if minuteNow.sign != minuteBefore.sign {
                minuteFuture = minuteNow
                minutePast = minuteBefore
                break
            }
        }

        guard let minutePast = minutePast else { return }
        guard let minuteFuture = minuteFuture else { return }

        // Pluto egresses sagittarius at 2008-11-26 17:03:00 -0800
        // Pluto ingresses capricorn at 2008-11-26 17:04:00 -0800
        let egressDate = Date(fromString: "2008-11-26 17:03:00 -0800", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2008-11-26 17:04:00 -0800", format: .cocoaDateTime)!
        XCTAssert(egressDate == minutePast.date)
        XCTAssert(ingressDate == minuteFuture.date)

        XCTAssert(minutePast.sign == Zodiac.sagittarius)
        XCTAssert(minuteFuture.sign == Zodiac.capricorn)

        let beforeString = minutePast.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = minuteFuture.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("Pluto egresses \(minutePast.sign) at \(beforeString)")
        print("Pluto ingresses \(minuteFuture.sign) at \(afterString)")
    }
}
