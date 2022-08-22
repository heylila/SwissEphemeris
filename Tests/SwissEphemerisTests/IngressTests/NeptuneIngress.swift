//
//  NeptuneIngress.swift
//  
//
//  Created by Sam Krishna on 8/21/22.
//

import XCTest
@testable import SwissEphemeris

class NeptuneIngress: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
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


    func testNeptuneEgressPisces() throws {
        let houses = ClevelandIngress.houseCusps
        let planet = Planet.neptune
        guard let tuple = PlutoIngress.signTransits[planet] else { return }
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

        // neptune egresses pisces at 2025-03-30 04:57:00 -0700
        // neptune ingresses aries at 2025-03-30 04:58:00 -0700
        let egressDate = Date(fromString: "2025-03-30 04:57:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2025-03-30 04:58:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == minutePast.date)
        XCTAssert(ingressDate == minuteFuture.date)

        XCTAssert(minutePast.sign == Zodiac.pisces)
        XCTAssert(minuteFuture.sign == Zodiac.aries)

        let beforeString = minutePast.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = minuteFuture.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(minutePast.sign) at \(beforeString)")
        print("\(planet) ingresses \(minuteFuture.sign) at \(afterString)")
    }

    func testNeptuneIngressPisces() throws {
        let planet = Planet.neptune
        guard let tuple = PlutoIngress.signTransits[planet] else { return }
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

        // neptune egresses aquarius at 2012-02-03 11:02:00 -0800
        // neptune ingresses pisces at 2012-02-03 11:03:00 -0800
        let egressDate = Date(fromString: "2012-02-03 11:02:00 -0800", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2012-02-03 11:03:00 -0800", format: .cocoaDateTime)!
        XCTAssert(egressDate == minutePast.date)
        XCTAssert(ingressDate == minuteFuture.date)

        XCTAssert(minutePast.sign == Zodiac.aquarius)
        XCTAssert(minuteFuture.sign == Zodiac.pisces)

        let beforeString = minutePast.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = minuteFuture.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(minutePast.sign) at \(beforeString)")
        print("\(planet) ingresses \(minuteFuture.sign) at \(afterString)")
    }
}
