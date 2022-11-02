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

    func testNeptuneEgressPisces() throws {
        let planet = Planet.neptune
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

    func testNeptuneNextHouseIngress() throws {
        let houses = ClevelandIngress.houseCusps
        let chart = BirthChart(date: ClevelandIngress.birthDate, latitude: houses.latitude, longitude: houses.longitude, houseSystem: .placidus)
        let planet = Planet.neptune
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(signTuple.dateType, value: signTuple.amount)!

        func sliceTimeForEgress(_ start: Date, _ stop: Date, _ timeSlice: Double) -> (egress: Coordinate, ingress: Coordinate)? {
            let positions = BodiesRequest(body: planet.celestialObject).fetch(start: start, end: stop, interval: timeSlice)

            return zip(positions, positions.dropFirst())
                .first { (now, later) in
                    let nowCusp = chart.houseCusps.cuspForLongitude(now.longitude)
                    let laterCusp = chart.houseCusps.cuspForLongitude(later.longitude)
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

        // egress date: 2034-04-28 05:33:00 -0700
        // ingress date: 2034-04-28 05:34:00 -0700
        let egressDate = Date(fromString: "2034-04-28 05:33:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2034-04-28 05:34:00 -0700", format: .cocoaDateTime)!
        XCTAssert(tuple.egress.date == egressDate, "actual egress is: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        XCTAssert(tuple.ingress.date == ingressDate, "actual ingress is: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")

        guard let egressCusp = chart.houseCusps.cuspForLongitude(tuple.egress.longitude) else { return }
        guard let ingressCusp = chart.houseCusps.cuspForLongitude(tuple.ingress.longitude) else { return }
        XCTAssert(egressCusp.name == "eleventh", "egressCusp name = \(egressCusp.name)")
        XCTAssert(ingressCusp.name == "twelfth", "ingressCusp name = \(ingressCusp.name)")
        print("egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        print("ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")
    }

    func testNeptunePriorHouseIngress() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.neptune
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

        // egress date: 2018-11-27 02:29:00 -0800
        // ingress date: 2018-11-27 02:30:00 -0800
        let egressDate = Date(fromString: "2017-01-23 14:20:00 -0800", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2017-01-23 14:21:00 -0800", format: .cocoaDateTime)!
        XCTAssert(tuple.egress.date == egressDate, "actual egress is: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        XCTAssert(tuple.ingress.date == ingressDate, "actual ingress is: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")

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
