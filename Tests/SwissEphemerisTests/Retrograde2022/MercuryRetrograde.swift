//
//  MercuryRetrograde.swift
//  
//
//  Created by Sam Krishna on 9/13/22.
//

import XCTest
@testable import SwissEphemeris

class MercuryRetrograde: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    func testMercuryRetrograde() throws {
        let start = Date(fromString: "2022-09-09 00:00:00 -0700")!
        let end = Date(fromString: "2022-10-02 23:59:00 -0700")!

        func testNextTuple<T>(_ now: Coordinate<T>, _ next: Coordinate<T>) -> Bool {
            if now.date > next.date { return false }
            if next.sign == Zodiac.pisces && now.sign == Zodiac.aries { return true }
            return next.longitude < now.longitude
        }

        func testPastTuple<T>(_ past: Coordinate<T>, _ now: Coordinate<T>) -> Bool {
            if past.date > now.date { return false }
            if past.sign == Zodiac.pisces && now.sign == Zodiac.aries { return false }
            return past.longitude > now.longitude
        }

        let positions: [Coordinate] = BodiesRequest(body: Planet.mercury).fetch(start: start, end: end)
        let offsetPositions = Array(positions.dropFirst()) + [positions.first!]

        let startRx: Coordinate<Planet>? = zip(positions, offsetPositions)
            .first { (now, next) in testNextTuple(now, next) }
            .map { $0.0 }

        let endRx: Coordinate<Planet>? = Array(zip(positions, offsetPositions))
            .last { (past, now) in testPastTuple(past, now) }
            .map { $0.1 }

        let startRxDate = Date(fromString: "2022-09-09 20:38:00 -0700")!
        let endRxDate = Date(fromString: "2022-10-02 02:07:00 -0700")!
        guard let startRx = startRx else { return }
        guard let endRx = endRx else { return }
        XCTAssert(startRx.date == startRxDate)
        XCTAssert(endRx.date == endRxDate)
    }
}
