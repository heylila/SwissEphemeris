//
//  ChironRetrograde.swift
//  
//
//  Created by Sam Krishna on 9/25/22.
//

import XCTest
@testable import SwissEphemeris

final class ChironRetrograde: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    // 2022-07-19 to 2022-12-23
    func testChironRetrograde() throws {
        // 6 months to check in either direction
        let now = Date(fromString: "2022-09-25 19:25:00 -0700")!
        var past = now.offset(.month, value: -6)!
        var future = now.offset(.month, value: 6)!
        let chiron = Asteroid.chiron
        let months = BodiesRequest(body: chiron).fetch(start: past, end: future, interval: TimeSlice.month.slice)
        let monthOffsets = Array(months.dropFirst()) + [months.first!]

        let startRxMonth: Coordinate<Asteroid>? = zip(months, monthOffsets)
            .first { (now, next) in next.longitude < now.longitude }
            .map { $0.0 }

        let endRxMonth: Coordinate<Asteroid>? = Array(zip(months, monthOffsets))
            .last { (past, now) in
                if past.date > now.date { return false }
                return past.longitude > now.longitude
            }
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

        let days = BodiesRequest(body: chiron).fetch(start: past, end: future, interval: TimeSlice.day.slice)
        let dayOffsets = Array(days.dropFirst()) + [days.first!]

        let startRxDay: Coordinate<Asteroid>? = zip(days, dayOffsets)
            .first { (now, next) in next.longitude < now.longitude }
            .map { $0.0 }

        let endRxDay: Coordinate<Asteroid>? = Array(zip(days, dayOffsets))
            .last { (past, now) in
                if past.date > now.date { return false }
                return past.longitude > now.longitude
            }
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

        let hours = BodiesRequest(body: chiron).fetch(start: past, end: future, interval: TimeSlice.hour.slice)
        let hourOffsets = Array(hours.dropFirst()) + [hours.first!]

        let startRxHour: Coordinate<Asteroid>? = zip(hours, hourOffsets)
            .first { (now, next) in next.longitude < now.longitude }
            .map { $0.0 }

        let endRxHour: Coordinate<Asteroid>? = Array(zip(hours, hourOffsets))
            .last { (past, now) in
                if past.date > now.date { return false }
                return past.longitude > now.longitude
            }
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

        let minutes = BodiesRequest(body: chiron).fetch(start: past, end: future, interval: TimeSlice.minute.slice)
        let minuteOffsets = Array(minutes.dropFirst()) + [minutes.first!]

        let startRxMinute: Coordinate<Asteroid>? = zip(minutes, minuteOffsets)
            .first { (now, next) in next.longitude < now.longitude }
            .map { $0.0 }

        let endRxMinute: Coordinate<Asteroid>? = Array(zip(minutes, minuteOffsets))
            .last { (past, now) in
                if past.date > now.date { return false }
                return past.longitude > now.longitude
            }
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

        // 2022-07-19 to 2022-12-23
        XCTAssert(minuteRxStart.component(.month)! == 7)
        XCTAssert(minuteRxStart.component(.day)! == 19)
        XCTAssert(minuteRxStart.component(.year)! == 2022)

        XCTAssert(minuteRxEnd.component(.month)! == 12)
        XCTAssert(minuteRxEnd.component(.day)! == 23)
        XCTAssert(minuteRxEnd.component(.year)! == 2022)
    }
}
