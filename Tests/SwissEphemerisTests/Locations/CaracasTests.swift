//
//  CaracasTests.swift
//  
//
//  Created by Sam Krishna on 9/21/22.
//

import XCTest
@testable import SwissEphemeris

final class CaracasTests: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        return Date(fromString: "1992-06-17 07:52:00 -0400", format: .cocoaDateTime)!
    }

    static var houseCusps1: HouseCusps {
        let lat = 10.4805937
        let long = -66.90360629999999
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    static var houseCusps2: HouseCusps {
        let lat = 10.38313599933997
        let long = -67.16380596646617
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testExample() throws {
        var chart = CaracasTests.houseCusps1
        let pluto = Coordinate(body: Planet.pluto, date: CaracasTests.birthDate)
        print("5th house = \(chart.fifth.value)")
        print("Pluto = \(pluto.longitude) and \(pluto.formatted)")

        chart = CaracasTests.houseCusps2
        print("5th house = \(chart.fifth.value)")
        print("Pluto = \(pluto.longitude) and \(pluto.formatted)")
    }

}
