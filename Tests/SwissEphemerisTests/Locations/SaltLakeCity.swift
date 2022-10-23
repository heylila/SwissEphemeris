//
//  SaltLakeCity.swift
//  
//
//  Created by Sam Krishna on 6/2/22.
//

import XCTest
@testable import SwissEphemeris

class SaltLakeCity: XCTestCase {

    // Location: Salt Lake City, UT
    // Lat: 40.7607793
    // Lng: -111.8910474
    // Birthdate: 1982-08-16 12:00:00 -0600
    // DIEAPIDIE

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        return Date(fromString: "1982-08-16 12:00:00 -0600", format: .cocoaDateTime, timeZone: .utc)!
    }

    static var houseCusps: HouseCusps {
        let lat = 40.7607793
        let long = -111.8910474
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testSun() throws {
        let body = Coordinate(body: Planet.sun.celestialObject, date: SaltLakeCity.birthDate)
        XCTAssert(body.sign == Zodiac.leo)
        XCTAssert(23 == Int32(body.degree))
        XCTAssert(31 == Int32(body.minute))
        XCTAssert(50 == round(body.second))
    }

    func testMoon() throws {
        let body = Coordinate(body: Planet.moon.celestialObject, date: SaltLakeCity.birthDate)
        XCTAssert(body.sign == Zodiac.cancer)
        XCTAssert(20 == Int32(body.degree))
        XCTAssert(58 == Int32(body.minute))
        XCTAssert(35 == Int32(body.second))
    }

    func testMercury() throws {
        let body = Coordinate(body: Planet.mercury.celestialObject, date: SaltLakeCity.birthDate)
        XCTAssert(body.sign == Zodiac.virgo)
        XCTAssert(13 == Int32(body.degree))
        XCTAssert(41 == Int32(body.minute))
        XCTAssert(44 == Int32(body.second))
    }

    func testVenus() throws {
        let body = Coordinate(body: Planet.venus.celestialObject, date: SaltLakeCity.birthDate)
        XCTAssert(body.sign == Zodiac.leo)
        XCTAssert(2 == Int32(body.degree))
        XCTAssert(47 == Int32(body.minute))
        XCTAssert(22 == round(body.second))
    }

    func testMars() throws {
        let body = Coordinate(body: Planet.mars.celestialObject, date: SaltLakeCity.birthDate)
        XCTAssert(body.sign == Zodiac.scorpio)
        XCTAssert(7 == Int32(body.degree))
        XCTAssert(48 == Int32(body.minute))
        XCTAssert(24 == round(body.second))
    }

    func testJupiter() throws {
        let body = Coordinate(body: Planet.jupiter.celestialObject, date: SaltLakeCity.birthDate)
        XCTAssert(body.sign == Zodiac.scorpio)
        XCTAssert(3 == Int32(body.degree))
        XCTAssert(54 == Int32(body.minute))
        XCTAssert(59 == round(body.second))
    }

    func testSaturn() throws {
        let body = Coordinate(body: Planet.saturn.celestialObject, date: SaltLakeCity.birthDate)
        XCTAssert(body.sign == Zodiac.libra)
        XCTAssert(18 == Int32(body.degree))
        XCTAssert(14 == Int32(body.minute))
        XCTAssert(17 == Int32(body.second))
    }

    func testUranus() throws {
        let body = Coordinate(body: Planet.uranus.celestialObject, date: SaltLakeCity.birthDate)
        XCTAssert(body.sign == Zodiac.sagittarius)
        XCTAssert(0 == Int32(body.degree))
        XCTAssert(35 == Int32(body.minute))
        XCTAssert(57 == Int32(body.second))
    }

    func testNeptune() throws {
        let body = Coordinate(body: Planet.neptune.celestialObject, date: SaltLakeCity.birthDate)
        XCTAssert(body.sign == Zodiac.sagittarius)
        XCTAssert(24 == Int32(body.degree))
        XCTAssert(22 == Int32(body.minute))
        XCTAssert(53 == round(body.second))
    }

    func testPluto() throws {
        let body = Coordinate(body: Planet.pluto.celestialObject, date: SaltLakeCity.birthDate)
        XCTAssert(body.sign == Zodiac.libra)
        XCTAssert(24 == Int32(body.degree))
        XCTAssert(37 == Int32(body.minute))
        XCTAssert(59 == Int32(body.second))
    }

    func testChiron() throws {
        let body = Coordinate(body: Asteroid.chiron.celestialObject, date: SaltLakeCity.birthDate)
        XCTAssert(body.sign == Zodiac.taurus)
        XCTAssert(27 == Int32(body.degree))
        XCTAssert(34 == Int32(body.minute))
        XCTAssert(59 == Int32(body.second))
    }

    func testHouse01() throws {
        let house = SaltLakeCity.houseCusps.first
        XCTAssert(house.sign == Zodiac.libra)
        XCTAssert(26 == Int32(house.degree))
        XCTAssert(1 == round(house.minute))
        XCTAssert(56 == round(house.second))
    }

    func testHouse02() throws {
        let house = SaltLakeCity.houseCusps.second
        XCTAssert(house.sign == Zodiac.scorpio)
        XCTAssert(23 == Int32(house.degree))
        XCTAssert(56 == Int32(house.minute))
        XCTAssert(14 == round(house.second))
    }

    func testHouse03() throws {
        let house = SaltLakeCity.houseCusps.third
        XCTAssert(house.sign == Zodiac.sagittarius)
        XCTAssert(25 == Int32(house.degree))
        XCTAssert(58 == Int32(house.minute))
        XCTAssert(33 == round(house.second))
    }

    func testHouse04() throws {
        let house = SaltLakeCity.houseCusps.fourth
        XCTAssert(house.sign == Zodiac.aquarius)
        XCTAssert(0 == Int32(house.degree))
        XCTAssert(42 == round(house.minute))
        XCTAssert(55 == round(house.second))
    }

    func testHouse05() throws {
        let house = SaltLakeCity.houseCusps.fifth
        XCTAssert(house.sign == Zodiac.pisces)
        XCTAssert(3 == Int32(house.degree))
        XCTAssert(57 == round(house.minute))
        XCTAssert(45 == round(house.second))
    }

    func testHouse06() throws {
        let house = SaltLakeCity.houseCusps.sixth
        XCTAssert(house.sign == Zodiac.aries)
        XCTAssert(2 == Int32(house.degree))
        XCTAssert(32 == Int32(house.minute))
        XCTAssert(15 == round(house.second))
    }

    func testHouse07() throws {
        let house = SaltLakeCity.houseCusps.seventh
        XCTAssert(house.sign == Zodiac.aries)
        XCTAssert(26 == Int32(house.degree))
        XCTAssert(1 == round(house.minute))
        XCTAssert(56 == round(house.second))
    }

    func testHouse08() throws {
        let house = SaltLakeCity.houseCusps.eighth
        XCTAssert(house.sign == Zodiac.taurus)
        XCTAssert(23 == Int32(house.degree))
        XCTAssert(56 == Int32(house.minute))
        XCTAssert(14 == round(house.second))
    }

    func testHouse09() throws {
        let house = SaltLakeCity.houseCusps.ninth
        XCTAssert(house.sign == Zodiac.gemini)
        XCTAssert(25 == Int32(house.degree))
        XCTAssert(58 == Int32(house.minute))
        XCTAssert(33 == round(house.second))
    }

    func testHouse10() throws {
        let house = SaltLakeCity.houseCusps.midHeaven
        XCTAssert(house.sign == Zodiac.leo)
        XCTAssert(0 == Int32(house.degree))
        XCTAssert(42 == round(house.minute))
        XCTAssert(55 == round(house.second))
    }

    func testHouse11() throws {
        let house = SaltLakeCity.houseCusps.eleventh
        XCTAssert(house.sign == Zodiac.virgo)
        XCTAssert(3 == Int32(house.degree))
        XCTAssert(57 == round(house.minute))
        XCTAssert(45 == round(house.second))
    }

    func testHouse12() throws {
        let house = SaltLakeCity.houseCusps.twelfth
        XCTAssert(house.sign == Zodiac.libra)
        XCTAssert(2 == Int32(house.degree))
        XCTAssert(32 == Int32(house.minute))
        XCTAssert(15 == round(house.second))
    }
}
