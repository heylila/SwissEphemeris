//
//  JupiterRetrograde.swift
//  
//
//  Created by Sam Krishna on 9/25/22.
//

import XCTest
@testable import SwissEphemeris

final class JupiterRetrograde: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    func testJupiterRetrograde() throws {
        // 6 months to check in either direction
        let now = Date(fromString: "2022-09-25 19:25:00 -0700")!
        var past = now.offset(.month, value: -6)!
        var future = now.offset(.month, value: 6)!

        func testNextTuple<T>(_ now: Coordinate<T>, _ next: Coordinate<T>) -> Bool {
            if now.date > next.date { return false }
            if now.sign == Zodiac.aries && next.sign == Zodiac.pisces { return true }
            if now.sign == Zodiac.pisces && next.sign == Zodiac.aries { return false }
            return now.longitude > next.longitude
        }

        func testPastTuple<T>(_ past: Coordinate<T>, _ now: Coordinate<T>) -> Bool {
            if now.date < past.date { return false }
            if now.sign == Zodiac.aries && past.sign == Zodiac.pisces { return false }
            if now.sign == Zodiac.pisces && past.sign == Zodiac.aries { return true }
            return now.longitude < past.longitude
        }

        func findRetrogradeDates<U>(target: U, _ past: Date, _ future: Date, _ time: TimeSlice) -> (past: Date, future: Date)? where U: CelestialBody {
            let positions = BodiesRequest(body: target).fetch(start: past, end: future, interval: time.slice)
            let offsets = Array(positions.dropFirst()) + [positions.first!]

            let startRx: Coordinate<U>? = zip(positions, offsets)
                .first { (now, next) in testNextTuple(now, next)}
                .map { $0.0 }

            let endRx: Coordinate<U>? = Array(zip(positions, offsets))
                .last { (past, now) in testPastTuple(past, now) }
                .map { $0.1 }

            guard let startRx = startRx else {
                XCTFail("We can't find the start of the retrograde... Punting")
                return nil
            }

            guard let endRx = endRx else {
                XCTFail("We can't find the end of the retrograde... Punting")
                return nil
            }

            return (startRx.date, endRx.date)
        }

        let timeDict = [
            TimeSlice.month : (component: Date.DateComponentType.month, value: 0),
            TimeSlice.day : (component: Date.DateComponentType.day, value: 30),
            TimeSlice.hour : (component: Date.DateComponentType.hour, value: 24),
            TimeSlice.minute : (component: Date.DateComponentType.minute, value: 60)
        ]

        let sliceIndex = 0
        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        for i in stride(from: sliceIndex, to: slices.endIndex, by: 1) {
            let time = slices[i]
            let offsetTuple = timeDict[time]!
            past = past.offset(offsetTuple.component, value: (-1 * offsetTuple.value))!
            future = future.offset(offsetTuple.component, value: offsetTuple.value)!
            let window = findRetrogradeDates(target: Planet.jupiter, past, future, time)
            guard let window = window else { break }
            past = window.past
            future = window.future
        }

        // 2022-07-28 to 2022-11-23
        XCTAssert(past.component(.month)! == 7, "Erroneoes Rx starting month is \(past.component(.month)!)")
        XCTAssert(past.component(.day)! == 28, "Erroneoes Rx starting day is \(past.component(.day)!)")
        XCTAssert(past.component(.year)! == 2022)

        XCTAssert(future.component(.month)! == 11, "Erroneoes Rx ending month is \(future.component(.month)!)")
        XCTAssert(future.component(.day)! == 23, "Erroneoes Rx ending day is \(future.component(.day)!)")
        XCTAssert(future.component(.year)! == 2022)
    }
}
