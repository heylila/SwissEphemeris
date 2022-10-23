//
//  PlutoIngress2.swift
//  
//
//  Created by Sam Krishna on 9/13/22.
//

import XCTest
@testable import SwissEphemeris

class PlutoIngress2: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        return Date(fromString: "1992-06-17 07:52:00 -0600")!
    }

    static var houseCusps: HouseCusps {
        // This is the lat/long for Mexico City, Mexico
        let lat: Double = 19.4326077
        let long: Double = -99.133208
        return HouseCusps(date: PlutoIngress2.birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testNatalPlutoLocation() throws {
        let chart = PlutoIngress2.houseCusps
        let pluto = Coordinate(body: Planet.pluto.celestialObject, date: PlutoIngress2.birthDate)
        let cusp = chart.cuspForLongitude(pluto.longitude)!
        XCTAssert(cusp.number == 5)
        XCTAssert(cusp.name == "fifth")

        // Pluto = 20 Degrees Scorpio ♏︎ 38' 11''
        XCTAssert(pluto.sign == Zodiac.scorpio)
        XCTAssert(Int(pluto.degree) == 20)
        XCTAssert(Int(pluto.minute) == 38)
        XCTAssert(Int(pluto.second) == 11)
    }
}
