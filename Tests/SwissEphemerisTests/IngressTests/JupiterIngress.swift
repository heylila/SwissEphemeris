//
//  JupiterIngress.swift
//  
//
//  Created by Sam Krishna on 8/21/22.
//

import XCTest
@testable import SwissEphemeris

class JupiterIngress: XCTestCase {

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


    func testJupiterEgressTaurus() throws {
        let houses = ClevelandIngress.houseCusps
        let planet = Planet.jupiter
        guard let tuple = JupiterIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(tuple.dateType, value: tuple.amount)!
        let monthSlice = Double(28 * 24 * 3600)
        let hourSlice = Double(3600)
        let minuteSlice = Double(60)
        let timeSlice = tuple.dateType == .month ? monthSlice : hourSlice
        var positions = BodiesRequest(body: planet).fetch(start: originDate, end: endDate, interval: timeSlice)
        var monthPast: Coordinate<Planet>?
        var monthFuture: Coordinate<Planet>?

        for i in stride(from: 0, to: positions.endIndex - 1, by: 1) {
            let monthNow = positions[i]
            let monthLater = positions[i + 1]

            if monthNow.sign != monthLater.sign {
                monthFuture = monthLater
                monthPast = monthNow
                break
            }
        }

        guard let monthPast = monthPast else { return }
        guard let monthFuture = monthFuture else { return }

        positions = BodiesRequest(body: planet).fetch(start: monthPast.date, end: monthFuture.date, interval: hourSlice)

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

        positions = BodiesRequest(body: planet).fetch(start: hourPast.date, end: hourFuture.date, interval: minuteSlice)
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

        // jupiter egresses aries at 2022-10-27 22:09:00 -0700
        // jupiter ingresses pisces at 2022-10-27 22:10:00 -0700
        let egressDate = Date(fromString: "2022-10-27 22:09:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-10-27 22:10:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == minutePast.date)
        XCTAssert(ingressDate == minuteFuture.date)

        XCTAssert(minutePast.sign == Zodiac.aries)
        XCTAssert(minuteFuture.sign == Zodiac.pisces)

        let beforeString = minutePast.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = minuteFuture.date.toString(format: .cocoaDateTime, timeZone: .local)!

#warning("Be Sure to mark as retrograde")
        print("\(planet) egresses \(minutePast.sign) at \(beforeString)")
        print("\(planet) ingresses \(minuteFuture.sign) at \(afterString)")
    }

    func testJupiterIngressPisces() throws {
        let planet = Planet.jupiter
        guard let tuple = JupiterIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let priorDate = originDate.offset(tuple.dateType, value: (-1 * tuple.amount))!
        let monthSlice = Double(28 * 24 * 3600)
        let hourSlice = Double(3600)
        let minuteSlice = Double(60)
        let timeSlice = tuple.dateType == .month ? monthSlice : hourSlice
        var positions = BodiesRequest(body: planet).fetch(start: priorDate, end: originDate, interval: timeSlice)
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

        positions = BodiesRequest(body: planet).fetch(start: monthPast.date, end: monthFuture.date, interval: hourSlice)

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

        positions = BodiesRequest(body: planet).fetch(start: hourPast.date, end: hourFuture.date, interval: minuteSlice)
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

        // jupiter egresses pisces at 2022-05-10 16:22:00 -0700
        // jupiter ingresses aries at 2022-05-10 16:23:00 -0700
        let egressDate = Date(fromString: "2022-05-10 16:22:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-05-10 16:23:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == minutePast.date)
        XCTAssert(ingressDate == minuteFuture.date)

        XCTAssert(minutePast.sign == Zodiac.pisces)
        XCTAssert(minuteFuture.sign == Zodiac.aries)

        let beforeString = minutePast.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = minuteFuture.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(minutePast.sign) at \(beforeString)")
        print("\(planet) ingresses \(minuteFuture.sign) at \(afterString)")
    }

}
