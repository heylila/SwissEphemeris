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

    func testJupiterEgressTaurus() throws {
        let planet = Planet.jupiter
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(signTuple.dateType, value: signTuple.amount)!

        func sliceTimeForEgress(_ start: Date, _ stop: Date, _ timeSlice: Double) -> (egress: Coordinate, ingress: Coordinate)? {
            let positions = BodiesRequest(body: planet.celestialObject).fetch(start: start, end: stop, interval: timeSlice)

            return zip(positions, positions.dropFirst())
                .first { (now, later) in now.sign != later.sign }
                .map { (now, later) in (now, later) }
        }

        let slices = TimeSlice.typicalSlices
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

        // jupiter egresses aries at 2022-10-27 22:09:00 -0700
        // jupiter ingresses pisces at 2022-10-27 22:10:00 -0700
        let egressDate = Date(fromString: "2022-10-27 22:09:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-10-27 22:10:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.aries)
        XCTAssert(tuple.ingress.sign == Zodiac.pisces)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(tuple.egress.sign) at \(beforeString)")
        print("\(planet) ingresses \(tuple.ingress.sign) at \(afterString)")
    }

    func testJupiterIngressPisces() throws {
        let planet = Planet.jupiter
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let priorDate = originDate.offset(signTuple.dateType, value: (-1 * signTuple.amount))!

        func sliceTimeForIngress(_ start: Date, _ stop: Date, _ timeSlice: Double) -> (egress: Coordinate, ingress: Coordinate)? {
            let positions = BodiesRequest(body: planet.celestialObject).fetch(start: start, end: stop, interval: timeSlice)

            return Array(zip(positions, positions.dropFirst()))
                .last { (now, later) in now.sign != later.sign }
                .map { (now, later) in (now, later) }
        }

        let slices = TimeSlice.typicalSlices
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

        // jupiter egresses pisces at 2022-05-10 16:22:00 -0700
        // jupiter ingresses aries at 2022-05-10 16:23:00 -0700
        let egressDate = Date(fromString: "2022-05-10 16:22:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-05-10 16:23:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.pisces)
        XCTAssert(tuple.ingress.sign == Zodiac.aries)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(tuple.egress.sign) at \(beforeString)")
        print("\(planet) ingresses \(tuple.ingress.sign) at \(afterString)")
    }

    func testCuspForLongitude() throws {
        let chart = ClevelandIngress.houseCusps
        let asc = chart.first.value
        let twelve = asc - 0.0001
        let one = asc + 0.0001

        var control12 = chart.cuspForLongitude(chart.twelfth.value)
        XCTAssert(control12!.name == "twelfth")
        control12 = chart.cuspForLongitude(twelve)
        XCTAssert(control12!.name == "twelfth")

        var control11 = chart.cuspForLongitude(350.0)
        XCTAssert(control11!.name == "eleventh")
        control11 = chart.cuspForLongitude(10.0)
        XCTAssert(control11!.name == "eleventh")

        var cusp1 = chart.cuspForLongitude(one)
        XCTAssert(cusp1!.name == "first", "cusp is wrong: \(cusp1!.name)")
        cusp1 = chart.cuspForLongitude(asc)
        XCTAssert(cusp1!.name == "first", "cusp is wrong: \(cusp1!.name)")
    }

    func testJupiterNextHouseIngress() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.jupiter
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(signTuple.dateType, value: signTuple.amount)!


        func sliceTimeForEgress(_ start: Date, _ stop: Date, _ timeSlice: Double) -> (egress: Coordinate, ingress: Coordinate)? {
            let positions = BodiesRequest(body: planet.celestialObject).fetch(start: start, end: stop, interval: timeSlice)

            return zip(positions, positions.dropFirst())
                .first { (now, later) in
                    // nowCusp(@nowCusp.name@) = @nowCusp.value@ and laterCusp(@laterCusp.name@) = @laterCusp.value@
                    let nowCusp = chart.cuspForLongitude(now.longitude)
                    let laterCusp = chart.cuspForLongitude(later.longitude)
                    return nowCusp != laterCusp
                }
                .map { (now, later) in (now, later) }
        }

        let slices = TimeSlice.typicalSlices
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

        // egress date: 2023-04-06 10:02:00 -0700
        // ingress date: 2023-04-06 10:03:00 -0700
        let egressDate = Date(fromString: "2023-04-06 10:02:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2023-04-06 10:03:00 -0700", format: .cocoaDateTime)!
        XCTAssert(tuple.egress.date == egressDate, "actual egress is: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        XCTAssert(tuple.ingress.date == ingressDate, "actual ingress is: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")

        guard let egressCusp = chart.cuspForLongitude(tuple.egress.longitude) else { return }
        guard let ingressCusp = chart.cuspForLongitude(tuple.ingress.longitude) else { return }
        XCTAssert(egressCusp.name == "eleventh", "egressCusp name = \(egressCusp.name)")
        XCTAssert(ingressCusp.name == "twelfth", "ingressCusp name = \(ingressCusp.name)")
        print("egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        print("ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")
    }

    func testJupiterPriorHouseIngress() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.jupiter
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

        let slices = TimeSlice.typicalSlices
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

        // egress date: 2022-02-14 03:01:00 -0800
        // ingress date: 2022-02-14 03:02:00 -0800
        let egressDate = Date(fromString: "2022-02-14 03:01:00 -0800", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-02-14 03:02:00 -0800", format: .cocoaDateTime)!
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

        XCTAssert(egressCusp.name == "tenth", "egressCusp name = \(egressCusp.name)")
        XCTAssert(ingressCusp.name == "eleventh", "ingressCusp name = \(ingressCusp.name)")
        print("egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        print("ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")
    }

}
