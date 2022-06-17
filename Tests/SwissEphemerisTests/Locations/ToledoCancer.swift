//
//  ToledoCancer.swift
//  
//
//  Created by Sam Krishna on 6/2/22.
//

import XCTest
@testable import SwissEphemeris

class ToledoCancer: XCTestCase {

    // Location: Toledo, OH
    // Lat: 41.6528052
    // Lng: -83.5378674
    // Birthdate: 1989-12-23 17:44:00 -0500
    // DIEAPIDIE

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        return Date(fromString: "1989-12-23 17:44:00 -0500", format: .cocoaDateTime, timeZone: .utc)!
    }

    static var houseCusps: HouseCusps {
        let lat = 41.6528052
        let long = -83.5378674
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testSun() throws {
        let body = Coordinate(body: Planet.sun, date: ToledoCancer.birthDate)
        XCTAssert(body.sign == Zodiac.capricorn)
        XCTAssert(2 == Int32(body.degree))
        XCTAssert(6 == round(body.minute))
        XCTAssert(44 == round(body.second))
    }

    func testMoon() throws {
        let body = Coordinate(body: Planet.moon, date: ToledoCancer.birthDate)
        XCTAssert(body.sign == Zodiac.scorpio)
        XCTAssert(15 == Int32(body.degree))
        XCTAssert(3 == round(body.minute))
        XCTAssert(27 == round(body.second))
    }

    func testMercury() throws {
        let body = Coordinate(body: Planet.mercury, date: ToledoCancer.birthDate)
        XCTAssert(body.sign == Zodiac.capricorn)
        XCTAssert(22 == Int32(body.degree))
        XCTAssert(2 == round(body.minute))
        XCTAssert(21 == round(body.second))
    }

    func testVenus() throws {
        let body = Coordinate(body: Planet.venus, date: ToledoCancer.birthDate)
        XCTAssert(body.sign == Zodiac.aquarius)
        XCTAssert(5 == Int32(body.degree))
        XCTAssert(51 == round(body.minute))
        XCTAssert(42 == round(body.second))
    }

    func testMars() throws {
        let body = Coordinate(body: Planet.mars, date: ToledoCancer.birthDate)
        XCTAssert(body.sign == Zodiac.sagittarius)
        XCTAssert(4 == Int32(body.degree))
        XCTAssert(0 == round(body.minute))
        XCTAssert(6 == round(body.second))
    }

    func testJupiter() throws {
        let body = Coordinate(body: Planet.jupiter, date: ToledoCancer.birthDate)
        XCTAssert(body.sign == Zodiac.cancer)
        XCTAssert(6 == Int32(body.degree))
        XCTAssert(18 == round(body.minute))
        XCTAssert(28 == round(body.second))
    }

    func testSaturn() throws {
        let body = Coordinate(body: Planet.saturn, date: ToledoCancer.birthDate)
        XCTAssert(body.sign == Zodiac.capricorn)
        XCTAssert(14 == Int32(body.degree))
        XCTAssert(39 == round(body.minute))
        XCTAssert(6 == round(body.second))
    }

    func testUranus() throws {
        let body = Coordinate(body: Planet.uranus, date: ToledoCancer.birthDate)
        XCTAssert(body.sign == Zodiac.capricorn)
        XCTAssert(5 == Int32(body.degree))
        XCTAssert(16 == round(body.minute))
        XCTAssert(15 == round(body.second))
    }

    func testNeptune() throws {
        let body = Coordinate(body: Planet.neptune, date: ToledoCancer.birthDate)
        XCTAssert(body.sign == Zodiac.capricorn)
        XCTAssert(11 == Int32(body.degree))
        XCTAssert(43 == round(body.minute))
        XCTAssert(54 == round(body.second))
    }

    func testPluto() throws {
        let body = Coordinate(body: Planet.pluto, date: ToledoCancer.birthDate)
        XCTAssert(body.sign == Zodiac.scorpio)
        XCTAssert(16 == Int32(body.degree))
        XCTAssert(50 == Int32(body.minute))
        XCTAssert(35 == round(body.second))
    }

    func testChiron() throws {
        let body = Coordinate(body: Asteroid.chiron, date: ToledoCancer.birthDate)
        XCTAssert(body.sign == Zodiac.cancer)
        XCTAssert(14 == Int32(body.degree))
        XCTAssert(23 == round(body.minute))
        XCTAssert(25 == round(body.second))
    }

    func testHouse01() throws {
        let house = ToledoCancer.houseCusps.first
        XCTAssert(house.sign == Zodiac.cancer)
        XCTAssert(11 == Int32(house.degree))
        XCTAssert(5 == Int32(house.minute))
        XCTAssert(58 == round(house.second))
    }

    func testHouse02() throws {
        let house = ToledoCancer.houseCusps.second
        XCTAssert(house.sign == Zodiac.leo)
        XCTAssert(0 == Int32(house.degree))
        XCTAssert(21 == Int32(house.minute))
        XCTAssert(43 == round(house.second))
    }

    func testHouse03() throws {
        let house = ToledoCancer.houseCusps.third
        XCTAssert(house.sign == Zodiac.leo)
        XCTAssert(21 == Int32(house.degree))
        XCTAssert(52 == Int32(house.minute))
        XCTAssert(56 == round(house.second))
    }

    func testHouse04() throws {
        let house = ToledoCancer.houseCusps.fourth
        XCTAssert(house.sign == Zodiac.virgo)
        XCTAssert(19 == Int32(house.degree))
        XCTAssert(1 == Int32(house.minute))
        XCTAssert(30 == round(house.second))
    }

    func testHouse05() throws {
        let house = ToledoCancer.houseCusps.fifth
        XCTAssert(house.sign == Zodiac.libra)
        XCTAssert(24 == Int32(house.degree))
        XCTAssert(35 == Int32(house.minute))
        XCTAssert(17 == round(house.second))
    }

    func testHouse06() throws {
        let house = ToledoCancer.houseCusps.sixth
        XCTAssert(house.sign == Zodiac.sagittarius)
        XCTAssert(5 == Int32(house.degree))
        XCTAssert(16 == Int32(house.minute))
        XCTAssert(56 == round(house.second))
    }

    func testHouse07() throws {
        let house = ToledoCancer.houseCusps.seventh
        XCTAssert(house.sign == Zodiac.capricorn)
        XCTAssert(11 == Int32(house.degree))
        XCTAssert(5 == Int32(house.minute))
        XCTAssert(58 == round(house.second))
    }

    func testHouse08() throws {
        let house = ToledoCancer.houseCusps.eighth
        XCTAssert(house.sign == Zodiac.aquarius)
        XCTAssert(0 == Int32(house.degree))
        XCTAssert(21 == Int32(house.minute))
        XCTAssert(43 == round(house.second))
    }

    func testHouse09() throws {
        let house = ToledoCancer.houseCusps.ninth
        XCTAssert(house.sign == Zodiac.aquarius)
        XCTAssert(21 == Int32(house.degree))
        XCTAssert(52 == Int32(house.minute))
        XCTAssert(56 == round(house.second))
    }

    func testHouse10() throws {
        let house = ToledoCancer.houseCusps.midHeaven
        XCTAssert(house.sign == Zodiac.pisces)
        XCTAssert(19 == Int32(house.degree))
        XCTAssert(1 == Int32(house.minute))
        XCTAssert(30 == round(house.second))
    }

    func testHouse11() throws {
        let house = ToledoCancer.houseCusps.eleventh
        XCTAssert(house.sign == Zodiac.aries)
        XCTAssert(24 == Int32(house.degree))
        XCTAssert(35 == Int32(house.minute))
        XCTAssert(17 == round(house.second))
    }

    func testHouse12() throws {
        let house = ToledoCancer.houseCusps.twelfth
        XCTAssert(house.sign == Zodiac.gemini)
        XCTAssert(5 == Int32(house.degree))
        XCTAssert(16 == Int32(house.minute))
        XCTAssert(56 == round(house.second))
    }
}
