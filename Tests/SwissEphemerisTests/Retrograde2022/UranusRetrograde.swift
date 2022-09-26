//
//  UranusRetrograde.swift
//  
//
//  Created by Sam Krishna on 9/25/22.
//

import XCTest
@testable import SwissEphemeris

final class UranusRetrograde: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    // 2022-08-24 to 2023-01-22
    func testUranusRetrograde() throws {
        // 6 months to check in either direction
        let now = Date(fromString: "2022-09-25 19:25:00 -0700")!
        var past = now.offset(.month, value: -6)!
        var future = now.offset(.month, value: 6)!
        let body = Planet.uranus
        let months = BodiesRequest(body: body).fetch(start: past, end: future, interval: TimeSlice.month.slice)
        let monthOffsets = Array(months.dropFirst()) + [months.first!]

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

        let startRxMonth: Coordinate<Planet>? = zip(months, monthOffsets)
            .first { (now, next) in testNextTuple(now, next) }
            .map { $0.0 }

        let endRxMonth: Coordinate<Planet>? = Array(zip(months, monthOffsets))
            .last { (past, now) in testPastTuple(past, now) }
            .map { $0.1 }

        guard let startRxMonth = startRxMonth else {
            XCTFail("We can't find the start of the retrograde... Punting")
            return
        }

        guard let endRxMonth = endRxMonth else {
            XCTFail("We can't find the end of the retrograde... Punting")
            return
        }

        past = startRxMonth.date.offset(.day, value: -30)!
        future = endRxMonth.date.offset(.day, value: 30)!

        let days = BodiesRequest(body: body).fetch(start: past, end: future, interval: TimeSlice.day.slice)
        let dayOffsets = Array(days.dropFirst()) + [days.first!]

        let startRxDay: Coordinate<Planet>? = zip(days, dayOffsets)
            .first { (now, next) in testNextTuple(now, next) }
            .map { $0.0 }

        let endRxDay: Coordinate<Planet>? = Array(zip(days, dayOffsets))
            .last { (past, now) in testPastTuple(past, now) }
            .map { $0.1 }

        guard let startRxDay = startRxDay else {
            XCTFail("We can't find the start of the retrograde... Punting")
            return
        }

        guard let endRxDay = endRxDay else {
            XCTFail("We can't find the end of the retrograde... Punting")
            return
        }

        past = startRxDay.date.offset(.hour, value: -24)!
        future = endRxDay.date.offset(.hour, value: 24)!

        let hours = BodiesRequest(body: body).fetch(start: past, end: future, interval: TimeSlice.hour.slice)
        let hourOffsets = Array(hours.dropFirst()) + [hours.first!]

        let startRxHour: Coordinate<Planet>? = zip(hours, hourOffsets)
            .first { (now, next) in testNextTuple(now, next) }
            .map { $0.0 }

        let endRxHour: Coordinate<Planet>? = Array(zip(hours, hourOffsets))
            .last { (past, now) in testPastTuple(past, now) }
            .map { $0.1 }

        guard let startRxHour = startRxHour else {
            XCTFail("We can't find the start of the retrograde... Punting")
            return
        }

        guard let endRxHour = endRxHour else {
            XCTFail("We can't find the end of the retrograde... Punting")
            return
        }

        past = startRxHour.date.offset(.minute, value: -60)!
        future = endRxHour.date.offset(.minute, value: 60)!

        let minutes = BodiesRequest(body: body).fetch(start: past, end: future, interval: TimeSlice.minute.slice)
        let minuteOffsets = Array(minutes.dropFirst()) + [minutes.first!]

        let startRxMinute: Coordinate<Planet>? = zip(minutes, minuteOffsets)
            .first { (now, next) in testNextTuple(now, next) }
            .map { $0.0 }

        let endRxMinute: Coordinate<Planet>? = Array(zip(minutes, minuteOffsets))
            .last { (past, now) in testPastTuple(past, now) }
            .map { $0.1 }

        guard let startRxMinute = startRxMinute else {
            XCTFail("We can't find the start of the retrograde... Punting")
            return
        }

        guard let endRxMinute = endRxMinute else {
            XCTFail("We can't find the end of the retrograde... Punting")
            return
        }

        let minuteRxStart = startRxMinute.date
        let minuteRxEnd = endRxMinute.date

        // 2022-08-24 to 2023-01-22
        XCTAssert(minuteRxStart.component(.month)! == 8)
        XCTAssert(minuteRxStart.component(.day)! == 24)
        XCTAssert(minuteRxStart.component(.year)! == 2022)

        XCTAssert(minuteRxEnd.component(.month)! == 1)
        XCTAssert(minuteRxEnd.component(.day)! == 22)
        XCTAssert(minuteRxEnd.component(.year)! == 2023)
    }

}
