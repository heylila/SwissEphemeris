//
//  MercuryIngress.swift
//  
//
//  Created by Sam Krishna on 8/21/22.
//

import XCTest
@testable import SwissEphemeris

class MercuryIngress: XCTestCase {

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


    func testMercuryEgressVirgo() throws {
        let planet = Planet.mercury
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

        // mercury egresses virgo at 2022-08-25 18:02:00 -0700
        // mercury ingresses libra at 2022-08-25 18:03:00 -0700
        let egressDate = Date(fromString: "2022-08-25 18:02:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-08-25 18:03:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.virgo)
        XCTAssert(tuple.ingress.sign == Zodiac.libra)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(tuple.egress.sign) at \(beforeString)")
        print("\(planet) ingresses \(tuple.ingress.sign) at \(afterString)")
    }

    func testMercuryIngressVirgo() throws {
        let planet = Planet.mercury
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

        // mercury egresses virgo at 2022-08-03 23:57:00 -0700
        // mercury ingresses leo at 2022-08-03 23:58:00 -0700
        let egressDate = Date(fromString: "2022-08-03 23:57:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-08-03 23:58:00 -0700", format: .cocoaDateTime)!
        XCTAssert(egressDate == tuple.egress.date)
        XCTAssert(ingressDate == tuple.ingress.date)

        XCTAssert(tuple.egress.sign == Zodiac.leo)
        XCTAssert(tuple.ingress.sign == Zodiac.virgo)

        let beforeString = tuple.egress.date.toString(format: .cocoaDateTime, timeZone: .local)!
        let afterString = tuple.ingress.date.toString(format: .cocoaDateTime, timeZone: .local)!

        print("\(planet) egresses \(tuple.egress.sign) at \(beforeString)")
        print("\(planet) ingresses \(tuple.ingress.sign) at \(afterString)")
    }

    func testMercuryNextIngress() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.mercury
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let endDate = originDate.offset(signTuple.dateType, value: signTuple.amount)!
        let origin = Coordinate(body: planet, date: originDate)

        // Find house of Mercury at start date:
        let offsetHouses = Array(chart.houses.dropFirst()) + [chart.first]
        var pair: (current: Cusp, next: Cusp)?

        for (current, next) in zip(chart.houses, offsetHouses) {
            if current.value <= origin.longitude && origin.longitude < next.value {
                pair = (current, next)
                break
            }
        }

        func sliceTimeForEgress(_ start: Date, _ stop: Date, _ timeSlice: Double, current: Cusp, next: Cusp) -> (egress: Coordinate<Planet>, ingress: Coordinate<Planet>)? {
            let range = current.value ... next.value
            let positions = BodiesRequest(body: planet).fetch(start: start, end: stop, interval: timeSlice)

            return zip(positions, positions.dropFirst())
                .first { (now, later) in range.contains(now.longitude) && !range.contains(later.longitude) }
                .map { (now, later) in (now, later) }
        }

        guard let pair = pair else { return }
        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        let sliceIndex = signTuple.dateType == .month ? 0 : 1
        var start = originDate
        var end = endDate
        var tuple: (egress: Coordinate<Planet>, ingress: Coordinate<Planet>)?

        for i in stride(from: sliceIndex, to: slices.endIndex, by: 1) {
            let time = slices[i]
            tuple = sliceTimeForEgress(start, end, time.slice, current: pair.current, next: pair.next)

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

        // egress date: 2022-10-23 21:06:00 -0700
        // ingress date: 2022-10-23 21:07:00 -0700
        let egressDate = Date(fromString: "2022-10-23 21:06:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-10-23 21:07:00 -0700", format: .cocoaDateTime)!
        XCTAssert(tuple.egress.date == egressDate)
        XCTAssert(tuple.ingress.date == ingressDate)

        guard let egressCusp = chart.cuspForLongitude(tuple.egress.longitude) else { return }
        guard let ingressCusp = chart.cuspForLongitude(tuple.ingress.longitude) else { return }
        XCTAssert(egressCusp.name == "fifth", "egressCusp name = \(egressCusp.name)")
        XCTAssert(ingressCusp.name == "sixth", "ingressCusp name = \(ingressCusp.name)")
        print("egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        print("ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")
    }

    func testMercuryPriorIngress() throws {
        let chart = ClevelandIngress.houseCusps
        let planet = Planet.mercury
        guard let signTuple = PlutoIngress.signTransits[planet] else { return }
        let originDate = Date(fromString: "2022-08-20 19:30:00 -0700", format: .cocoaDateTime)!
        let priorDate = originDate.offset(signTuple.dateType, value: (-1 * signTuple.amount))!
        let origin = Coordinate(body: planet, date: originDate)

        // Find house of Mercury at start date:
        let offsetHouses = Array(chart.houses.dropFirst()) + [chart.first]
        var pair: (current: Cusp, next: Cusp)?

        for (current, next) in zip(chart.houses, offsetHouses) {
            if current.value <= origin.longitude && origin.longitude < next.value {
                pair = (current, next)
                break
            }
        }

        func sliceTimeForEgress(_ start: Date, _ stop: Date, _ timeSlice: Double, current: Cusp, next: Cusp) -> (egress: Coordinate<Planet>, ingress: Coordinate<Planet>)? {
            let range = current.value ... next.value
            let positions = BodiesRequest(body: planet).fetch(start: start, end: stop, interval: timeSlice)

            return Array(zip(positions, positions.dropFirst()))
                .last { (now, later) in !range.contains(now.longitude) && range.contains(later.longitude) }
                .map { (now, later) in (now, later) }
        }

        guard let pair = pair else { return }
        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        let sliceIndex = signTuple.dateType == .month ? 0 : 1
        var start = priorDate
        var end = originDate
        var tuple: (egress: Coordinate<Planet>, ingress: Coordinate<Planet>)?

        for i in stride(from: sliceIndex, to: slices.endIndex, by: 1) {
            let time = slices[i]
            tuple = sliceTimeForEgress(start, end, time.slice, current: pair.current, next: pair.next)

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

        // egress date: 2022-08-10 11:34:00 -0700
        // ingress date: 2022-08-10 11:35:00 -0700
        let egressDate = Date(fromString: "2022-08-10 11:34:00 -0700", format: .cocoaDateTime)!
        let ingressDate = Date(fromString: "2022-08-10 11:35:00 -0700", format: .cocoaDateTime)!
        XCTAssert(tuple.egress.date == egressDate)
        XCTAssert(tuple.ingress.date == ingressDate)

        guard let egressCusp = chart.cuspForLongitude(tuple.egress.longitude) else { return }
        guard let ingressCusp = chart.cuspForLongitude(tuple.ingress.longitude) else { return }
        XCTAssert(egressCusp.name == "fourth", "egressCusp name = \(egressCusp.name)")
        XCTAssert(ingressCusp.name == "fifth", "ingressCusp name = \(ingressCusp.name)")
        print("egress date: \(tuple.egress.date.toString(format: .cocoaDateTime)!)")
        print("ingress date: \(tuple.ingress.date.toString(format: .cocoaDateTime)!)")
    }

}
