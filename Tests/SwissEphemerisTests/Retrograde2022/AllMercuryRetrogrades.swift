//
//  AllMercuryRetrogrades.swift
//  
//
//  Created by Sam Krishna on 9/27/22.
//

import XCTest
@testable import SwissEphemeris

public struct Celestial : Codable {
    enum CodingKeys : String, CodingKey {
        case planet = "Planet"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case startLongitude = "StartLongitude"
        case endLongitude = "EndLongitude"
    }

    let planet: String
    let startDate: Date
    let endDate: Date
    let startLongitude: Double
    let endLongitude: Double

    // Blake's requested open-and-closed Mercury retrogrades
    //    {
    //        "Planet": "Mercury",
    //        "StartDate": "2022-02-19T03:51:00Z",
    //        "EndDate": "2022-02-21T09:18:30Z",
    //        "StartLongitude": 209.9999,
    //        "EndLongitude": 10
    //    }

    // How it ended up:
    //    {
    //      "Planet" : "Mercury",
    //      "EndLongitude" : 294.37826179257138,
    //      "StartLongitude" : 310.31219379334334,
    //      "EndDate" : "2022-02-04T00:00:00Z",
    //      "StartDate" : "2022-01-15T00:00:00Z"
    //    }
}

final class AllMercuryRetrogrades: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

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

    func testDiscoverNearbyWindows() throws {
        let startOfYear = Date(fromString: "2022-01-01 00:00:00 +0000")!
        let endOfYear = Date(fromString: "2024-12-31 23:59:59 +0000")!
        let positions = BodiesRequest(body: Planet.mercury).fetch(start: startOfYear, end: endOfYear, interval: TimeSlice.day.slice)
        let offsets = Array(positions.dropFirst()) + [positions.first!]

        let retrogrades = zip(positions, offsets)
            .filter { (now, next) in
                return testNextTuple(now, next)
            }
            .map { (now, next) in
                return next
            }

        let retroOffsets = Array(retrogrades.dropFirst()) + [retrogrades.first!]
        var retroGroup = [Coordinate<Planet>]()
        var retroGroups = [[Coordinate<Planet>]]()

        for (now, next) in zip(retrogrades, retroOffsets) {
            if retroGroup.count == 0 {
                retroGroup.append(now)
                continue
            }

            retroGroup.append(now)

            if next.date.since(now.date, in: .day)! > 1 || next.date.since(now.date, in: .day)! < 0 {
                retroGroups.append(retroGroup)
                retroGroup.removeAll()
            }
        }

        let timeDict = [
            TimeSlice.month : (component: Date.DateComponentType.month, value: 0),
            TimeSlice.day : (component: Date.DateComponentType.day, value: 30),
            TimeSlice.hour : (component: Date.DateComponentType.hour, value: 24),
            TimeSlice.minute : (component: Date.DateComponentType.minute, value: 60)
        ]

        let sliceIndex = 1
        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        var retroGroups2 = [[Coordinate<Planet>]]()
        let planet = Planet.mercury

        for group in retroGroups {
            var past = group.first!.date
            var future = group.last!.date

            for i in stride(from: sliceIndex, to: slices.endIndex, by: 1) {
                let time = slices[i]
                let offsetTuple = timeDict[time]!
                past = past.offset(offsetTuple.component, value: (-1 * offsetTuple.value))!
                future = future.offset(offsetTuple.component, value: offsetTuple.value)!
                let window = findRetrogradeDates(target: planet, past, future, time)
                if let window {
                    past = window.past
                    future = window.future
                }
            }

            let rxPositions = BodiesRequest(body: planet).fetch(start: past, end: future, interval: TimeSlice.minute.slice)
            retroGroups2.append(rxPositions)
        }

        var celestials = [Celestial]()

        for group in retroGroups2 {
            let start = group.first!
            let end = group.last!
            let c = Celestial(planet: "Mercury", startDate: start.date, endDate: end.date, startLongitude: start.longitude, endLongitude: end.longitude)
            celestials.append(c)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(celestials)
        print(String(data: jsonData, encoding: .utf8)!)
    }
}
