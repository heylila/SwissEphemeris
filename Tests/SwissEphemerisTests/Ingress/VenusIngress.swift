//
//  VenusIngress.swift
//  
//
//  Created by Sam Krishna on 8/21/22.
//

import XCTest
@testable import SwissEphemeris

class VenusIngress: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    func testVenusEgressLeo() throws {
        let planet = Planet.venus
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

        // venus egresses leo at 2022-09-04 21:05:00 -0700
        // venus ingresses virgo at 2022-09-04 21:06:00 -0700
        let egressDate = Date(fromString: "2022-09-04 21:05:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-09-04 21:06:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.leo)
        XCTAssert(tuple.ingress.sign == Zodiac.virgo)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(tuple.egress.sign) at \(beforeString)")
        print("\(planet) ingresses \(tuple.ingress.sign) at \(afterString)")
    }

    func testVenusIngressLeo() throws {
        let planet = Planet.venus
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

        // venus ingresses leo at 2022-08-11 11:30:00 -0700
        // venus egresses cancer at 2022-08-11 11:31:00 -0700
        let egressDate = Date(fromString: "2022-08-11 11:30:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-08-11 11:31:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.cancer)
        XCTAssert(tuple.ingress.sign == Zodiac.leo)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) ingresses \(tuple.ingress.sign) at \(beforeString)")
        print("\(planet) egresses \(tuple.egress.sign) at \(afterString)")
    }

    func testVenusNextHouseIngress() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.venus
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

        let egressDate = Date(fromString: "2022-08-21 00:47:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-08-21 00:48:00 -0700", format: .cocoaDateTime)!
        XCTAssert(tuple.egress.date == egressDate, "actual egress is: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        XCTAssert(tuple.ingress.date == ingressDate, "actual ingress is: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")

        guard let egressCusp = chart.cuspForLongitude(tuple.egress.longitude) else { return }
        guard let ingressCusp = chart.cuspForLongitude(tuple.ingress.longitude) else { return }
        XCTAssert(egressCusp.name == "third", "egressCusp name = \(egressCusp.name)")
        XCTAssert(ingressCusp.name == "fourth", "ingressCusp name = \(ingressCusp.name)")
        print("egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        print("ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")
    }

    func testVenusPriorHouseIngress() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.venus
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

        let egressDate = Date(fromString: "2022-08-02 21:40:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-08-02 21:41:00 -0700", format: .cocoaDateTime)!
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

        XCTAssert(egressCusp.name == "second", "egressCusp name = \(egressCusp.name)")
        XCTAssert(ingressCusp.name == "third", "ingressCusp name = \(ingressCusp.name)")
        print("egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        print("ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")
    }


}
