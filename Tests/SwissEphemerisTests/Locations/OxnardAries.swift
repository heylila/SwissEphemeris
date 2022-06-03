//
//  OxnardAries.swift
//  
//
//  Created by Sam Krishna on 6/2/22.
//

import XCTest
@testable import SwissEphemeris

class OxnardAries: XCTestCase {

    // Location: Oxnard, CA
    // Lat: 34.1975048
    // Lng: -119.1770516
    // Birthdate: 1981-09-18 19:47:00 -0700

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        return Date(fromString: "1981-09-18 19:47:00 -0700", format: .cocoaDateTime, timeZone: .utc)!
    }

    static var houseCusps: HouseCusps {
        let lat = 34.1975048
        let long = -119.1770516
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testSun() throws {
        let body = Coordinate(body: Planet.sun, date: OxnardAries.birthDate)
        XCTAssert(body.sign == Zodiac.virgo)
        XCTAssert(26 == Int32(body.degree))
        XCTAssert(4 == Int32(body.minute))
        XCTAssert(33 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testMoon() throws {
        let body = Coordinate(body: Planet.moon, date: OxnardAries.birthDate)
        XCTAssert(body.sign == Zodiac.gemini)
        XCTAssert(3 == Int32(body.degree))
        XCTAssert(28 == Int32(body.minute))
        XCTAssert(57 == Int32(body.second))
        XCTAssert(-4 == Int32(body.latitude))
    }

    func testMercury() throws {
        let body = Coordinate(body: Planet.mercury, date: OxnardAries.birthDate)
        XCTAssert(body.sign == Zodiac.libra)
        XCTAssert(21 == Int32(body.degree))
        XCTAssert(51 == Int32(body.minute))
        XCTAssert(17 == Int32(body.second))
        XCTAssert(-2 == Int32(body.latitude))
    }

    func testVenus() throws {
        let body = Coordinate(body: Planet.venus, date: OxnardAries.birthDate)
        XCTAssert(body.sign == Zodiac.scorpio)
        XCTAssert(7 == Int32(body.degree))
        XCTAssert(11 == Int32(body.minute))
        XCTAssert(6 == Int32(body.second))
        XCTAssert(-1 == Int32(body.latitude))
    }

    func testMars() throws {
        let body = Coordinate(body: Planet.mars, date: OxnardAries.birthDate)
        XCTAssert(body.sign == Zodiac.leo)
        XCTAssert(10 == Int32(body.degree))
        XCTAssert(42 == Int32(body.minute))
        XCTAssert(23 == Int32(body.second))
        XCTAssert(1 == Int32(body.latitude))
    }

    func testJupiter() throws {
        let body = Coordinate(body: Planet.jupiter, date: OxnardAries.birthDate)
        XCTAssert(body.sign == Zodiac.libra)
        XCTAssert(15 == Int32(body.degree))
        XCTAssert(21 == Int32(body.minute))
        XCTAssert(57 == round(body.second))
        XCTAssert(1 == Int32(body.latitude))
    }

    func testSaturn() throws {
        let body = Coordinate(body: Planet.saturn, date: OxnardAries.birthDate)
        XCTAssert(body.sign == Zodiac.libra)
        XCTAssert(10 == Int32(body.degree))
        XCTAssert(45 == Int32(body.minute))
        XCTAssert(6 == Int32(body.second))
        XCTAssert(2 == Int32(body.latitude))
    }

    func testUranus() throws {
        let body = Coordinate(body: Planet.uranus, date: OxnardAries.birthDate)
        XCTAssert(body.sign == Zodiac.scorpio)
        XCTAssert(26 == Int32(body.degree))
        XCTAssert(55 == Int32(body.minute))
        XCTAssert(55 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testNeptune() throws {
        let body = Coordinate(body: Planet.neptune, date: OxnardAries.birthDate)
        XCTAssert(body.sign == Zodiac.sagittarius)
        XCTAssert(22 == Int32(body.degree))
        XCTAssert(9 == Int32(body.minute))
        XCTAssert(13 == Int32(body.second))
        XCTAssert(1 == Int32(body.latitude))
    }

    func testPluto() throws {
        let body = Coordinate(body: Planet.pluto, date: OxnardAries.birthDate)
        XCTAssert(body.sign == Zodiac.libra)
        XCTAssert(23 == Int32(body.degree))
        XCTAssert(9 == Int32(body.minute))
        XCTAssert(27 == Int32(body.second))
        XCTAssert(16 == Int32(body.latitude))
    }

    func testChiron() throws {
        let body = Coordinate(body: Asteroid.chiron, date: OxnardAries.birthDate)
        XCTAssert(body.sign == Zodiac.taurus)
        XCTAssert(22 == Int32(body.degree))
        XCTAssert(36 == Int32(body.minute))
        XCTAssert(58 == Int32(body.second))
        XCTAssert(-2 == Int32(body.latitude))
    }

    func testHouse01() throws {
        let house = OxnardAries.houseCusps.first
        XCTAssert(house.sign == Zodiac.aries)
        XCTAssert(16 == Int32(house.degree))
        XCTAssert(5 == Int32(house.minute))
        XCTAssert(12 == Int32(house.second))
    }

    func testHouse02() throws {
        let house = OxnardAries.houseCusps.second
        XCTAssert(house.sign == Zodiac.taurus)
        XCTAssert(21 == Int32(house.degree))
        XCTAssert(29 == Int32(house.minute))
        XCTAssert(51 == Int32(house.second))
    }

    func testHouse03() throws {
        let house = OxnardAries.houseCusps.third
        XCTAssert(house.sign == Zodiac.gemini)
        XCTAssert(17 == Int32(house.degree))
        XCTAssert(8 == Int32(house.minute))
        XCTAssert(55 == Int32(house.second))
    }

    func testHouse04() throws {
        let house = OxnardAries.houseCusps.fourth
        XCTAssert(house.sign == Zodiac.cancer)
        XCTAssert(9 == Int32(house.degree))
        XCTAssert(38 == Int32(house.minute))
        XCTAssert(55 == Int32(house.second))
    }

    func testHouse05() throws {
        let house = OxnardAries.houseCusps.fifth
        XCTAssert(house.sign == Zodiac.leo)
        XCTAssert(3 == Int32(house.degree))
        XCTAssert(35 == Int32(house.minute))
        XCTAssert(6 == Int32(house.second))
    }

    func testHouse06() throws {
        let house = OxnardAries.houseCusps.sixth
        XCTAssert(house.sign == Zodiac.virgo)
        XCTAssert(3 == Int32(house.degree))
        XCTAssert(59 == Int32(house.minute))
        XCTAssert(49 == Int32(house.second))
    }

    func testHouse07() throws {
        let house = OxnardAries.houseCusps.seventh
        XCTAssert(house.sign == Zodiac.libra)
        XCTAssert(16 == Int32(house.degree))
        XCTAssert(5 == Int32(house.minute))
        XCTAssert(12 == Int32(house.second))
    }

    func testHouse08() throws {
        let house = OxnardAries.houseCusps.eighth
        XCTAssert(house.sign == Zodiac.scorpio)
        XCTAssert(21 == Int32(house.degree))
        XCTAssert(29 == Int32(house.minute))
        XCTAssert(51 == Int32(house.second))
    }

    func testHouse09() throws {
        let house = OxnardAries.houseCusps.ninth
        XCTAssert(house.sign == Zodiac.sagittarius)
        XCTAssert(17 == Int32(house.degree))
        XCTAssert(8 == Int32(house.minute))
        XCTAssert(55 == Int32(house.second))
    }

    func testHouse10() throws {
        let house = OxnardAries.houseCusps.midHeaven
        XCTAssert(house.sign == Zodiac.capricorn)
        XCTAssert(9 == Int32(house.degree))
        XCTAssert(38 == Int32(house.minute))
        XCTAssert(55 == Int32(house.second))
    }

    func testHouse11() throws {
        let house = OxnardAries.houseCusps.eleventh
        XCTAssert(house.sign == Zodiac.aquarius)
        XCTAssert(3 == Int32(house.degree))
        XCTAssert(35 == Int32(house.minute))
        XCTAssert(6 == Int32(house.second))
    }

    func testHouse12() throws {
        let house = OxnardAries.houseCusps.twelfth
        XCTAssert(house.sign == Zodiac.pisces)
        XCTAssert(3 == Int32(house.degree))
        XCTAssert(59 == Int32(house.minute))
        XCTAssert(49 == Int32(house.second))
    }
}
