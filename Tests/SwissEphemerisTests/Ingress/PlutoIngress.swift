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
            .sun : (.day, 40),
            .mercury : (.day, 70),
            .venus : (.day, 75),
            .mars : (.month, 8),
            .jupiter : (.month, 24),
            .saturn : (.month, Int(2.8 * 12)),
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
        let planet = Planet.pluto
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

        // Pluto egresses sagittarius at 2008-11-26 17:03:00 -0800
        // Pluto ingresses capricorn at 2008-11-26 17:04:00 -0800
        let egressDate = Date(fromString: "2008-11-26 17:03:00 -0800", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2008-11-26 17:04:00 -0800", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.sagittarius)
        XCTAssert(tuple.ingress.sign == Zodiac.capricorn)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) inresses \(tuple.ingress.sign) at \(beforeString)")
        print("\(planet) egresses \(tuple.egress.sign) at \(afterString)")
    }

    func testPlutoNextHouseIngress() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.pluto
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

        // egress date: 2030-04-02 19:25:00 -0700
        // ingress date: 2030-04-02 19:26:00 -0700
        let egressDate = Date(fromString: "2030-04-02 19:25:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2030-04-02 19:26:00 -0700", format: .cocoaDateTime)!
        XCTAssert(tuple.egress.date == egressDate)
        XCTAssert(tuple.ingress.date == ingressDate)

        guard let egressCusp = chart.cuspForLongitude(tuple.egress.longitude) else { return }
        guard let ingressCusp = chart.cuspForLongitude(tuple.ingress.longitude) else { return }
        XCTAssert(egressCusp.name == "ninth", "egressCusp name = \(egressCusp.name)")
        XCTAssert(ingressCusp.name == "tenth", "ingressCusp name = \(ingressCusp.name)")
        print("egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        print("ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")
    }

    func testPlutoPriorHouseIngress() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.pluto
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

        // egress date: 2018-11-27 02:29:00 -0800
        // ingress date: 2018-11-27 02:30:00 -0800
        let egressDate = Date(fromString: "2018-11-27 02:29:00 -0800", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2018-11-27 02:30:00 -0800", format: .cocoaDateTime)!
        XCTAssert(tuple.egress.date == egressDate)
        XCTAssert(tuple.ingress.date == ingressDate)

        guard let egressCusp = chart.cuspForLongitude(tuple.egress.longitude) else { return }
        guard let ingressCusp = chart.cuspForLongitude(tuple.ingress.longitude) else { return }
        XCTAssert(egressCusp.name == "eighth", "egressCusp name = \(egressCusp.name)")
        XCTAssert(ingressCusp.name == "ninth", "ingressCusp name = \(ingressCusp.name)")
        print("egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        print("ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")
    }

}
