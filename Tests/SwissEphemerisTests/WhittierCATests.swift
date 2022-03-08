//
//  WhittierTests.swift
//  
//
//  Created by Sam Krishna on 3/7/22.
//

import XCTest
@testable import SwissEphemeris

/// As a user, I want to be able to generate the expected results from a transiting moon aspect to a natal chart in order to be able to check the accuracy of my code.
///
/// In order to do this, I need to generate a "testable" birth chart (birth date, location, and time) that I can use to look for transiting aspects from the Moon.
///
/// When I input the Moon's location by degree, I can generate:
/// - A "testable" birth chart – the birth date, the birth time, and the birth location – one that contains planets in that sign (a specific degree range).
/// - The exact date and time (in UTC) of the conjunction aspect from the Moon to planets in that sign (a specific degree range).
/// - A four hour range for the event spanning from exactly 2 hours before to 2 hours after (in UTC).

// All Lunar conjunctions with Birth Chart planets over any given 7 day window
// +/-2 hours in either direction of the conjunction
// Include the time of the precise (as close to 0° for the conjunction) to the minute

final class WhittierCATests: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    // 1989-01-11 05:03:00 UTC
    // Whittier, CA, USA
    // Lat: 33.9791793
    // Long: -118.032844

    static var birthDate: Date {
        return Date(fromString: "1989-01-11 05:03:00 +0000", format: .cocoaDateTime, timeZone: .utc)!
    }

    static var houseSystem: HouseCusps {
        let lat = 33.9791793
        let long = -118.032844
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    static var planets: [String : Coordinate<Planet>] {
        let dict = [
            Planet.sun.symbol : Coordinate(body: Planet.sun, date: birthDate),
            Planet.moon.symbol : Coordinate(body: .moon, date: birthDate),
            Planet.mercury.symbol : Coordinate(body: .mercury, date: birthDate),
            Planet.venus.symbol : Coordinate(body: .venus, date: birthDate),
            Planet.mars.symbol : Coordinate(body: .mars, date: birthDate),
            Planet.jupiter.symbol : Coordinate(body: .jupiter, date: birthDate),
            Planet.saturn.symbol : Coordinate(body: .saturn, date: birthDate),
            Planet.uranus.symbol : Coordinate(body: .uranus, date: birthDate),
            Planet.neptune.symbol : Coordinate(body: .neptune, date: birthDate),
            Planet.pluto.symbol : Coordinate(body: .pluto, date: birthDate)
        ]

        return dict
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test7DaysFrom20220307() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.


//        let start = Date(fromString: "2022-03-07 13:00:00 -0800", format: .cocoaDateTime)!
//        let end = start.offset(.day, value: 7)
//
//        for (planetName, planet) in WhittierCATests.planets {
//            
//        }

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
