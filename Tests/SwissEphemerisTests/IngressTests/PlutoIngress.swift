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
            .mercury : (.day, 60),
            .venus : (.day, 60),
            .mars : (.month, 7),
            .jupiter : (.month, 12),
            .saturn : (.month, Int(2.5 * 12)),
            .uranus : (.month, Int(7 * 15)),
            .neptune : (.month, Int(14 * 12)),
            .pluto : (.month, Int(31 * 12))
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
        let houses = ClevelandIngress.houseCusps
        let pluto = Planet.pluto
        guard let plutoTuple = PlutoIngress.signTransits[pluto] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(plutoTuple.dateType, value: plutoTuple.amount)!
        let monthSlice = Double(28 * 24 * 3600)
        let hourSlice = Double(3600)
        let minuteSlice = Double(60)
        let timeSlice = plutoTuple.dateType == .month ? monthSlice : hourSlice
        var positions = BodiesRequest(body: pluto).fetch(start: originDate, end: endDate, interval: timeSlice)
        var plutoPast: Coordinate<Planet>?
        var plutoFuture: Coordinate<Planet>?

        for i in stride(from: 0, to: positions.endIndex - 1, by: 1) {
            let plutoNow = positions[i]
            let plutoLater = positions[i + 1]

            if plutoNow.sign != plutoLater.sign {
                plutoFuture = plutoLater
                plutoPast = plutoNow
                break
            }
        }

        guard let plutoPast = plutoPast else { return }
        guard let plutoFuture = plutoFuture else { return }

        positions = BodiesRequest(body: pluto).fetch(start: plutoPast.date, end: plutoFuture.date, interval: hourSlice)

        var hourPast: Coordinate<Planet>?
        var hourFuture: Coordinate<Planet>?

        for i in stride(from: 0, to: positions.endIndex - 1, by: 1) {
            let hourNow = positions[i]
            let hourLater = positions[i + 1]
            if hourNow.sign != hourLater.sign {
                hourFuture = hourLater
                hourPast = hourNow
                break
            }
        }

        guard let hourPast = hourPast else { return }
        guard let hourFuture = hourFuture else { return }

        positions = BodiesRequest(body: pluto).fetch(start: hourPast.date, end: hourFuture.date, interval: minuteSlice)
        var minutePast: Coordinate<Planet>?
        var minuteFuture: Coordinate<Planet>?

        for i in stride(from: 0, to: positions.endIndex - 1, by: 1) {
            let minuteNow = positions[i]
            let minuteLater = positions[i + 1]
            if minuteNow.sign != minuteLater.sign {
                minuteFuture = minuteLater
                minutePast = minuteNow
                break
            }
        }

        guard let minutePast = minutePast else { return }
        guard let minuteFuture = minuteFuture else { return }

        // Pluto egresses capricorn at 2023-03-23 05:23:00 -0700
        // Pluto ingresses aquarius at 2023-03-23 05:24:00 -0700
        let egressDate = Date(fromString: "2023-03-23 05:23:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2023-03-23 05:24:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == minutePast.date)
        XCTAssert(ingressDate == minuteFuture.date)

        XCTAssert(minutePast.sign == Zodiac.capricorn)
        XCTAssert(minuteFuture.sign == Zodiac.aquarius)

        let beforeString = minutePast.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = minuteFuture.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("Pluto egresses \(minutePast.sign) at \(beforeString)")
        print("Pluto ingresses \(minuteFuture.sign) at \(afterString)")
    }

    func testPlutoIngressCapricorn() throws {
        let pluto = Planet.pluto
        guard let plutoTuple = PlutoIngress.signTransits[pluto] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let priorDate = originDate.offset(plutoTuple.dateType, value: (-1 * plutoTuple.amount))!
        let monthSlice = Double(28 * 24 * 3600)
        let hourSlice = Double(3600)
        let minuteSlice = Double(60)
        let timeSlice = plutoTuple.dateType == .month ? monthSlice : hourSlice
        var positions = BodiesRequest(body: pluto).fetch(start: priorDate, end: originDate, interval: timeSlice)
        var plutoPast: Coordinate<Planet>?
        var plutoFuture: Coordinate<Planet>?

        for i in stride(from: positions.endIndex - 1, to: 1, by: -1) {
            let plutoNow = positions[i]
            let plutoBefore = positions[i - 1]

            if plutoNow.sign != plutoBefore.sign {
                plutoFuture = plutoNow
                plutoPast = plutoBefore
                break
            }
        }

        guard let plutoPast = plutoPast else { return }
        guard let plutoFuture = plutoFuture else { return }

        positions = BodiesRequest(body: pluto).fetch(start: plutoPast.date, end: plutoFuture.date, interval: hourSlice)

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

        positions = BodiesRequest(body: pluto).fetch(start: hourPast.date, end: hourFuture.date, interval: minuteSlice)
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
