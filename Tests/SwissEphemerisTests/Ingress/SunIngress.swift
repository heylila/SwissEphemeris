//
//  SunIngress.swift
//  
//
//  Created by Sam Krishna on 8/21/22.
//

import XCTest
@testable import SwissEphemeris

class SunIngress: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
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

    func testSunEgressLeo() throws {
        let planet = Planet.sun
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(signTuple.dateType, value: signTuple.amount)!

        func sliceTimeForEgress(_ start: Date, _ stop: Date, _ timeSlice: Double) -> (egress: Coordinate, ingress: Coordinate)? {
            let positions = BodiesRequest(body: planet.celestialObject).fetch(start: start, end: stop, interval: timeSlice)

            return zip(positions, positions.dropFirst())
                .first { (now, later) in now.sign != later.sign }
                .map { (now, later) in (now, later) }
        }

        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        let sliceIndex = signTuple.dateType == .month ? 0 : 1
        var start = originDate
        var end = endDate
        var ingressTuple: (egress: Coordinate, ingress: Coordinate)?

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

        // sun egresses leo at 2022-08-22 20:16:00 -0700
        // sun ingresses virgo at 2022-08-22 20:17:00 -0700
        let egressDate = Date(fromString: "2022-08-22 20:16:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-08-22 20:17:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.leo)
        XCTAssert(tuple.ingress.sign == Zodiac.virgo)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(tuple.egress.sign) at \(beforeString)")
        print("\(planet) ingresses \(tuple.ingress.sign) at \(afterString)")
    }

    func testSunIngressLeo() throws {
        let planet = Planet.sun
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let priorDate = originDate.offset(signTuple.dateType, value: (-1 * signTuple.amount))!

        func sliceTimeForIngress(_ start: Date, _ stop: Date, _ timeSlice: Double) -> (egress: Coordinate, ingress: Coordinate)? {
            let positions = BodiesRequest(body: planet.celestialObject).fetch(start: start, end: stop, interval: timeSlice)

            return Array(zip(positions, positions.dropFirst()))
                .last { (now, later) in now.sign != later.sign }
                .map { (now, later) in (now, later) }
        }

        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        let sliceIndex = signTuple.dateType == .month ? 0 : 1
        var start = priorDate
        var end = originDate
        var ingressTuple: (egress: Coordinate, ingress: Coordinate)?

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

        // sun egresses cancer at 2022-07-22 13:06:00 -0700
        // sun ingresses leo at 2022-07-22 13:07:00 -0700
        let egressDate = Date(fromString: "2022-07-22 13:06:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-07-22 13:07:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.cancer)
        XCTAssert(tuple.ingress.sign == Zodiac.leo)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(tuple.egress.sign) at \(beforeString)")
        print("\(planet) ingresses \(tuple.ingress.sign) at \(afterString)")
    }

    func testSunNextHouseIngress() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.sun
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(signTuple.dateType, value: signTuple.amount)!


        func sliceTimeForEgress(_ start: Date, _ stop: Date, _ timeSlice: Double) -> (egress: Coordinate, ingress: Coordinate)? {
            let positions = BodiesRequest(body: planet.celestialObject).fetch(start: start, end: stop, interval: timeSlice)

            return zip(positions, positions.dropFirst())
                .first { (now, later) in
                    let nowCusp = chart.cuspForLongitude(now.longitude)
                    let laterCusp = chart.cuspForLongitude(later.longitude)
                    return nowCusp != laterCusp
                }
                .map { (now, later) in (now, later) }
        }

        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        let sliceIndex = signTuple.dateType == .month ? 0 : 1
        var start = originDate
        var end = endDate
        var tuple: (egress: Coordinate, ingress: Coordinate)?

        for i in stride(from: sliceIndex, to: slices.endIndex, by: 1) {
            let time = slices[i]
            tuple = sliceTimeForEgress(start, end, time.slice)

            guard let ingressTuple = tuple else {
                XCTFail("We have a failure for a given time slice: \(time)")
                return
            }

            start = ingressTuple.egress.date
            end = ingressTuple.ingress.date
            assert(start < end)
        }

        guard let tuple = tuple else {
            XCTFail("There was no egress moment. Go back and check your window...")
            return
        }

        // egress date: 2022-09-02 13:52:00 -0700
        // ingress date: 2022-09-02 13:53:00 -0700
        let egressDate = Date(fromString: "2022-09-02 13:52:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-09-02 13:53:00 -0700", format: .cocoaDateTime)!
        XCTAssert(tuple.egress.date == egressDate, "actual egress is: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        XCTAssert(tuple.ingress.date == ingressDate, "actual ingress is: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")

        guard let egressCusp = chart.cuspForLongitude(tuple.egress.longitude) else { return }
        guard let ingressCusp = chart.cuspForLongitude(tuple.ingress.longitude) else { return }
        XCTAssert(egressCusp.name == "fourth", "egressCusp name = \(egressCusp.name)")
        XCTAssert(ingressCusp.name == "fifth", "ingressCusp name = \(ingressCusp.name)")
        print("egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        print("ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")
    }

    func testSunPriorHouseIngress() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.sun
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let priorDate = originDate.offset(signTuple.dateType, value: (-1 * signTuple.amount))!

        func sliceTimeForEgress(_ start: Date, _ stop: Date, _ timeSlice: Double) -> (egress: Coordinate, ingress: Coordinate)? {
            let positions = BodiesRequest(body: planet.celestialObject).fetch(start: start, end: stop, interval: timeSlice)

            return Array(zip(positions, positions.dropFirst()))
                .last { (now, later) in
                    let nowCusp = chart.cuspForLongitude(now.longitude)
                    let laterCusp = chart.cuspForLongitude(later.longitude)
                    return nowCusp != laterCusp
                }
                .map { (now, later) in (now, later) }
        }

        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        let sliceIndex = signTuple.dateType == .month ? 0 : 1
        var start = priorDate
        var end = originDate
        var tuple: (egress: Coordinate, ingress: Coordinate)?

        for i in stride(from: sliceIndex, to: slices.endIndex, by: 1) {
            let time = slices[i]
            tuple = sliceTimeForEgress(start, end, time.slice)

            guard let ingressTuple = tuple else {
                XCTFail("We have a failure for a given time slice: \(time)")
                return
            }

            start = ingressTuple.egress.date
            end = ingressTuple.ingress.date
        }

        guard let tuple = tuple else {
            XCTFail("There was no egress moment. Go back and check your window...")
            return
        }

        // egress date: 2016-04-10 09:17:00 -0700
        // ingress date: 2016-04-10 09:18:00 -0700
        let egressDate = Date(fromString: "2022-08-03 18:52:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-08-03 18:53:00 -0700", format: .cocoaDateTime)!
        XCTAssert(tuple.egress.date == egressDate, "actual egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        XCTAssert(tuple.ingress.date == ingressDate, "actual ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")

        guard let egressCusp = chart.cuspForLongitude(tuple.egress.longitude) else {
            XCTFail("We don't have an egress cusp!")
            return
        }
        guard let ingressCusp = chart.cuspForLongitude(tuple.ingress.longitude) else {
            XCTFail("We don't have an ingress cusp!")
            return
        }

        XCTAssert(egressCusp.name == "third", "egressCusp name = \(egressCusp.name)")
        XCTAssert(ingressCusp.name == "fourth", "ingressCusp name = \(ingressCusp.name)")
        print("egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        print("ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")
    }
}
