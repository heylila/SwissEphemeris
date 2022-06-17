//
//  FresnoCapricorn.swift
//  
//
//  Created by Sam Krishna on 6/2/22.
//

import XCTest
@testable import SwissEphemeris

class FresnoCapricorn: XCTestCase {

    // Location: Fresno, CA
    // Lat: 36.7377981
    // Lng: -119.7871247
    // Birthdate: 1977-07-13 18:51:00 -0700
    // DIEAPIDIE

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        return Date(fromString: "1977-07-13 18:51:00 -0700", format: .cocoaDateTime, timeZone: .utc)!
    }

    static var houseCusps: HouseCusps {
        let lat = 36.7377981
        let long = -119.7871247
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testSun() throws {
        let body = Coordinate(body: Planet.sun, date: FresnoCapricorn.birthDate)
        XCTAssert(body.sign == Zodiac.cancer)
        XCTAssert(21 == Int32(body.degree))
        XCTAssert(31 == Int32(body.minute))
        XCTAssert(10 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testMoon() throws {
        let body = Coordinate(body: Planet.moon, date: FresnoCapricorn.birthDate)
        XCTAssert(body.sign == Zodiac.gemini)
        XCTAssert(26 == Int32(body.degree))
        XCTAssert(0 == Int32(body.minute))
        XCTAssert(53 == Int32(body.second))
        XCTAssert(-4 == Int32(body.latitude))
    }

    func testMercury() throws {
        let body = Coordinate(body: Planet.mercury, date: FresnoCapricorn.birthDate)
        XCTAssert(body.sign == Zodiac.leo)
        XCTAssert(6 == Int32(body.degree))
        XCTAssert(47 == Int32(body.minute))
        XCTAssert(23 == Int32(body.second))
        XCTAssert(1 == Int32(body.latitude))
    }

    func testVenus() throws {
        let body = Coordinate(body: Planet.venus, date: FresnoCapricorn.birthDate)
        XCTAssert(body.sign == Zodiac.gemini)
        XCTAssert(8 == Int32(body.degree))
        XCTAssert(0 == Int32(body.minute))
        XCTAssert(58 == Int32(body.second))
        XCTAssert(-2 == Int32(body.latitude))
    }

    func testMars() throws {
        let body = Coordinate(body: Planet.mars, date: FresnoCapricorn.birthDate)
        XCTAssert(body.sign == Zodiac.taurus)
        XCTAssert(27 == Int32(body.degree))
        XCTAssert(30 == Int32(body.minute))
        XCTAssert(38 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testJupiter() throws {
        let body = Coordinate(body: Planet.jupiter, date: FresnoCapricorn.birthDate)
        XCTAssert(body.sign == Zodiac.gemini)
        XCTAssert(22 == Int32(body.degree))
        XCTAssert(39 == Int32(body.minute))
        XCTAssert(17 == round(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testSaturn() throws {
        let body = Coordinate(body: Planet.saturn, date: FresnoCapricorn.birthDate)
        XCTAssert(body.sign == Zodiac.leo)
        XCTAssert(16 == Int32(body.degree))
        XCTAssert(36 == Int32(body.minute))
        XCTAssert(37 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testUranus() throws {
        let body = Coordinate(body: Planet.uranus, date: FresnoCapricorn.birthDate)
        XCTAssert(body.sign == Zodiac.scorpio)
        XCTAssert(7 == Int32(body.degree))
        XCTAssert(41 == Int32(body.minute))
        XCTAssert(19 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testNeptune() throws {
        let body = Coordinate(body: Planet.neptune, date: FresnoCapricorn.birthDate)
        XCTAssert(body.sign == Zodiac.sagittarius)
        XCTAssert(13 == Int32(body.degree))
        XCTAssert(49 == Int32(body.minute))
        XCTAssert(24 == Int32(body.second))
        XCTAssert(1 == Int32(body.latitude))
    }

    func testPluto() throws {
        let body = Coordinate(body: Planet.pluto, date: FresnoCapricorn.birthDate)
        XCTAssert(body.sign == Zodiac.libra)
        XCTAssert(11 == Int32(body.degree))
        XCTAssert(32 == Int32(body.minute))
        XCTAssert(23 == Int32(body.second))
        XCTAssert(16 == Int32(body.latitude))
    }

    func testChiron() throws {
        let body = Coordinate(body: Asteroid.chiron, date: FresnoCapricorn.birthDate)
        XCTAssert(body.sign == Zodiac.taurus)
        XCTAssert(5 == Int32(body.degree))
        XCTAssert(28 == Int32(body.minute))
        XCTAssert(3 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testHouse1() throws {
        let house = FresnoCapricorn.houseCusps.first
        XCTAssert(house.sign == Zodiac.capricorn)
        XCTAssert(0 == Int32(house.degree))
        XCTAssert(49 == Int32(house.minute))
        XCTAssert(56 == Int32(house.second))
    }

    func testHouse2() throws {
        let house = FresnoCapricorn.houseCusps.second
        XCTAssert(house.sign == Zodiac.aquarius)
        XCTAssert(7 == Int32(house.degree))
        XCTAssert(50 == Int32(house.minute))
        XCTAssert(24 == Int32(house.second))
    }

    func testHouse3() throws {
        let house = FresnoCapricorn.houseCusps.third
        XCTAssert(house.sign == Zodiac.pisces)
        XCTAssert(17 == Int32(house.degree))
        XCTAssert(33 == Int32(house.minute))
        XCTAssert(40 == Int32(house.second))
    }

    func testHouse4() throws {
        let house = FresnoCapricorn.houseCusps.fourth
        XCTAssert(house.sign == Zodiac.aries)
        XCTAssert(21 == Int32(house.degree))
        XCTAssert(24 == Int32(house.minute))
        XCTAssert(37 == Int32(house.second))
    }

    func testHouse5() throws {
        let house = FresnoCapricorn.houseCusps.fifth
        XCTAssert(house.sign == Zodiac.taurus)
        XCTAssert(17 == Int32(house.degree))
        XCTAssert(48 == Int32(house.minute))
        XCTAssert(44 == Int32(house.second))
    }

    func testHouse6() throws {
        let house = FresnoCapricorn.houseCusps.sixth
        XCTAssert(house.sign == Zodiac.gemini)
        XCTAssert(9 == Int32(house.degree))
        XCTAssert(47 == Int32(house.minute))
        XCTAssert(13 == Int32(house.second))
    }

    func testHouse7() throws {
        let house = FresnoCapricorn.houseCusps.seventh
        XCTAssert(house.sign == Zodiac.cancer)
        XCTAssert(0 == Int32(house.degree))
        XCTAssert(49 == Int32(house.minute))
        XCTAssert(56 == Int32(house.second))
    }

    func testHouse8() throws {
        let house = FresnoCapricorn.houseCusps.eighth
        XCTAssert(house.sign == Zodiac.leo)
        XCTAssert(7 == Int32(house.degree))
        XCTAssert(50 == Int32(house.minute))
        XCTAssert(24 == Int32(house.second))
    }

    func testHouse9() throws {
        let house = FresnoCapricorn.houseCusps.ninth
        XCTAssert(house.sign == Zodiac.virgo)
        XCTAssert(17 == Int32(house.degree))
        XCTAssert(33 == Int32(house.minute))
        XCTAssert(40 == Int32(house.second))
    }

    func testHouse10() throws {
        let house = FresnoCapricorn.houseCusps.midHeaven
        XCTAssert(house.sign == Zodiac.libra)
        XCTAssert(21 == Int32(house.degree))
        XCTAssert(24 == Int32(house.minute))
        XCTAssert(37 == Int32(house.second))
    }

    func testHouse11() throws {
        let house = FresnoCapricorn.houseCusps.eleventh
        XCTAssert(house.sign == Zodiac.scorpio)
        XCTAssert(17 == Int32(house.degree))
        XCTAssert(48 == Int32(house.minute))
        XCTAssert(44 == Int32(house.second))
    }

    func testHouse12() throws {
        let house = FresnoCapricorn.houseCusps.twelfth
        XCTAssert(house.sign == Zodiac.sagittarius)
        XCTAssert(9 == Int32(house.degree))
        XCTAssert(47 == Int32(house.minute))
        XCTAssert(13 == Int32(house.second))
    }
}
