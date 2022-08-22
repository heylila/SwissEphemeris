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
        let planet = Planet.neptune
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

        // neptune egresses pisces at 2025-03-30 04:57:00 -0700
        // neptune ingresses aries at 2025-03-30 04:58:00 -0700
        let egressDate = Date(fromString: "2025-03-30 04:57:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2025-03-30 04:58:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.pisces)
        XCTAssert(tuple.ingress.sign == Zodiac.aries)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(tuple.egress.sign) at \(beforeString)")
        print("\(planet) ingresses \(tuple.ingress.sign) at \(afterString)")
    }

    func testNeptuneIngressPisces() throws {
        let planet = Planet.neptune
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

        // neptune egresses aquarius at 2012-02-03 11:02:00 -0800
        // neptune ingresses pisces at 2012-02-03 11:03:00 -0800
        let egressDate = Date(fromString: "2012-02-03 11:02:00 -0800", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2012-02-03 11:03:00 -0800", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.aquarius)
        XCTAssert(tuple.ingress.sign == Zodiac.pisces)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(tuple.egress.sign) at \(beforeString)")
        print("\(planet) ingresses \(tuple.ingress.sign) at \(afterString)")
    }
}
