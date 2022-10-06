//
//  AllRetrogrades.swift
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
}

final class AllRetrogrades: XCTestCase {

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

    func discoverWindows<T>(_ target: T, _ targetName: String) where T: CelestialBody {
        let startOfYear = Date(fromString: "2021-12-01 00:00:00 +0000")!
        let endOfYear = Date(fromString: "2032-12-31 23:59:59 +0000")!
        let positions = BodiesRequest(body: target).fetch(start: startOfYear, end: endOfYear, interval: TimeSlice.day.slice)
        let offsets = Array(positions.dropFirst()) + [positions.first!]

        let retrogrades = zip(positions, offsets)
            .filter { (now, next) in
                return testNextTuple(now, next)
            }
            .map { (now, next) in
                return next
            }

        let retroOffsets = Array(retrogrades.dropFirst()) + [retrogrades.first!]
        var retroGroup = [Coordinate<T>]()
        var retroGroups = [[Coordinate<T>]]()

        for (now, next) in zip(retrogrades, retroOffsets) {
            if retroGroup.count == 0 {
                retroGroup.append(now)
                continue
            }

            if next.date.since(now.date, in: .day)! > 1 || next.date.since(now.date, in: .day)! < 0 {
                retroGroup.append(now)
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

        let sliceIndex = 2
        let slices: [TimeSlice] = [ .month, .day, .hour, .minute ]
        var retroGroups2 = [(start: Coordinate<T>, end: Coordinate<T>)]()

        for group in retroGroups {
            var past = group.first!.date
            var future = group.last!.date

            for i in stride(from: sliceIndex, to: slices.endIndex, by: 1) {
                let time = slices[i]
                let offsetTuple = timeDict[time]!
                past = past.offset(offsetTuple.component, value: (-1 * offsetTuple.value))!
                future = future.offset(offsetTuple.component, value: offsetTuple.value)!
                let window = findRetrogradeDates(target: target, past, future, time)
                if let window {
                    past = window.past
                    future = window.future
                }
            }

            let rxStart = Coordinate(body: target, date: past)
            let rxEnd = Coordinate(body: target, date: future)
            let rxPositions = (start: rxStart, end: rxEnd)
            retroGroups2.append(rxPositions)
        }

        var celestials = [Celestial]()

        for group in retroGroups2 {
            let start = group.start
            let end = group.end
            let c = Celestial(planet: targetName, startDate: start.date, endDate: end.date, startLongitude: start.longitude, endLongitude: end.longitude)
            celestials.append(c)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601

        do {
            let jsonData = try encoder.encode(celestials)
            print("\n*******")
            print(String(data: jsonData, encoding: .utf8)!)
            print("*******")
        } catch {
            print(error)
        }
    }


    func testDiscoverNearbyWindows() throws {
        let target = LunarNode.trueSouthNode
        let targetName = "South Node"

        discoverWindows(target, targetName)
    }
}
