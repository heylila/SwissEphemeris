//
//  ChalonsTests.swift
//  
//
//  Created by Sam Krishna on 6/2/22.
//

import XCTest
@testable import SwissEphemeris

class ChalonsTests: XCTestCase {

    // Châlons-en-Champagne, France
    // Lat: 48.956682
    // Lng: 4.363073
    // Date: 1908-05-05 09:20:39 +0000 (UTC)

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        return Date(fromString: "1908-05-05 09:20:39 +0000", format: .cocoaDateTime, timeZone: .utc)!
    }

    static var houseCusps: HouseCusps {
        let lat = 48.956682
        let long = 4.363073
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testSun() throws {
        let body = Coordinate(body: Planet.sun, date: ChalonsTests.birthDate)
        XCTAssert(body.sign == Zodiac.taurus)
        XCTAssert(14 == Int32(body.degree))
        XCTAssert(27 == Int32(body.minute))
        XCTAssert(49 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testMoon() throws {
        let body = Coordinate(body: Planet.moon, date: ChalonsTests.birthDate)
        XCTAssert(body.sign == Zodiac.cancer)
        XCTAssert(10 == Int32(body.degree))
        XCTAssert(41 == Int32(body.minute))
        XCTAssert(13 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testMercury() throws {
        let body = Coordinate(body: Planet.mercury, date: ChalonsTests.birthDate)
        XCTAssert(body.sign == Zodiac.taurus)
        XCTAssert(11 == Int32(body.degree))
        XCTAssert(38 == Int32(body.minute))
        XCTAssert(49 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testVenus() throws {
        let body = Coordinate(body: Planet.venus, date: ChalonsTests.birthDate)
        XCTAssert(body.sign == Zodiac.gemini)
        XCTAssert(29 == Int32(body.degree))
        XCTAssert(41 == Int32(body.minute))
        XCTAssert(13 == Int32(body.second))
        XCTAssert(3 == Int32(body.latitude))
    }

    func testMars() throws {
        let body = Coordinate(body: Planet.mars, date: ChalonsTests.birthDate)
        XCTAssert(body.sign == Zodiac.gemini)
        XCTAssert(18 == Int32(body.degree))
        XCTAssert(44 == Int32(body.minute))
        XCTAssert(32 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testJupiter() throws {
        let body = Coordinate(body: Planet.jupiter, date: ChalonsTests.birthDate)
        XCTAssert(body.sign == Zodiac.leo)
        XCTAssert(5 == Int32(body.degree))
        XCTAssert(29 == Int32(body.minute))
        XCTAssert(37 == round(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testSaturn() throws {
        let body = Coordinate(body: Planet.saturn, date: ChalonsTests.birthDate)
        XCTAssert(body.sign == Zodiac.aries)
        XCTAssert(5 == Int32(body.degree))
        XCTAssert(32 == Int32(body.minute))
        XCTAssert(52 == Int32(body.second))
        XCTAssert(-2 == Int32(body.latitude))
    }

    func testUranus() throws {
        let body = Coordinate(body: Planet.uranus, date: ChalonsTests.birthDate)
        XCTAssert(body.sign == Zodiac.capricorn)
        XCTAssert(16 == Int32(body.degree))
        XCTAssert(49 == Int32(body.minute))
        XCTAssert(40 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testNeptune() throws {
        let body = Coordinate(body: Planet.neptune, date: ChalonsTests.birthDate)
        XCTAssert(body.sign == Zodiac.cancer)
        XCTAssert(12 == Int32(body.degree))
        XCTAssert(34 == Int32(body.minute))
        XCTAssert(24 == Int32(body.second))
        XCTAssert(0 == Int32(body.latitude))
    }

    func testPluto() throws {
        let body = Coordinate(body: Planet.pluto, date: ChalonsTests.birthDate)
        XCTAssert(body.sign == Zodiac.gemini)
        XCTAssert(23 == Int32(body.degree))
        XCTAssert(22 == Int32(body.minute))
        XCTAssert(27 == Int32(body.second))
        XCTAssert(-7 == Int32(body.latitude))
    }

    func testChiron() throws {
        let body = Coordinate(body: Asteroid.chiron, date: ChalonsTests.birthDate)
        XCTAssert(body.sign == Zodiac.aquarius)
        XCTAssert(23 == Int32(body.degree))
        XCTAssert(6 == Int32(body.minute))
        XCTAssert(39 == Int32(body.second))
        XCTAssert(6 == Int32(body.latitude))
    }

    func testHouse1() throws {
        let house = ChalonsTests.houseCusps.first
        XCTAssert(house.sign == Zodiac.leo)
        XCTAssert(0 == Int32(house.degree))
        XCTAssert(5 == Int32(house.minute))
        XCTAssert(44 == Int32(house.second))
    }

    func testHouse2() throws {
        let house = ChalonsTests.houseCusps.second
        XCTAssert(house.sign == Zodiac.leo)
        XCTAssert(17 == Int32(house.degree))
        XCTAssert(24 == Int32(house.minute))
        XCTAssert(42 == Int32(house.second))
    }

    func testHouse3() throws {
        let house = ChalonsTests.houseCusps.third
        XCTAssert(house.sign == Zodiac.virgo)
        XCTAssert(8 == Int32(house.degree))
        XCTAssert(57 == Int32(house.minute))
        XCTAssert(0 == Int32(house.second))
    }

    func testHouse4() throws {
        let house = ChalonsTests.houseCusps.fourth
        XCTAssert(house.sign == Zodiac.libra)
        XCTAssert(8 == Int32(house.degree))
        XCTAssert(1 == Int32(house.minute))
        XCTAssert(32 == Int32(house.second))
    }

    func testHouse5() throws {
        let house = ChalonsTests.houseCusps.fifth
        XCTAssert(house.sign == Zodiac.scorpio)
        XCTAssert(16 == Int32(house.degree))
        XCTAssert(36 == Int32(house.minute))
        XCTAssert(24 == Int32(house.second))
    }

    func testHouse6() throws {
        let house = ChalonsTests.houseCusps.sixth
        XCTAssert(house.sign == Zodiac.sagittarius)
        XCTAssert(27 == Int32(house.degree))
        XCTAssert(29 == Int32(house.minute))
        XCTAssert(38 == Int32(house.second))
    }

    func testHouse7() throws {
        let house = ChalonsTests.houseCusps.seventh
        XCTAssert(house.sign == Zodiac.aquarius)
        XCTAssert(0 == Int32(house.degree))
        XCTAssert(5 == Int32(house.minute))
        XCTAssert(44 == Int32(house.second))
    }

    func testHouse8() throws {
        let house = ChalonsTests.houseCusps.eighth
        XCTAssert(house.sign == Zodiac.aquarius)
        XCTAssert(17 == Int32(house.degree))
        XCTAssert(24 == Int32(house.minute))
        XCTAssert(42 == Int32(house.second))
    }

    func testHouse9() throws {
        let house = ChalonsTests.houseCusps.ninth
        XCTAssert(house.sign == Zodiac.pisces)
        XCTAssert(8 == Int32(house.degree))
        XCTAssert(57 == Int32(house.minute))
        XCTAssert(0 == Int32(house.second))
    }

    func testHouse10() throws {
        let house = ChalonsTests.houseCusps.midHeaven
        XCTAssert(house.sign == Zodiac.aries)
        XCTAssert(8 == Int32(house.degree))
        XCTAssert(1 == Int32(house.minute))
        XCTAssert(32 == Int32(house.second))
    }

    func testHouse11() throws {
        let house = ChalonsTests.houseCusps.eleventh
        XCTAssert(house.sign == Zodiac.taurus)
        XCTAssert(16 == Int32(house.degree))
        XCTAssert(36 == Int32(house.minute))
        XCTAssert(24 == Int32(house.second))
    }

    func testHouse12() throws {
        let house = ChalonsTests.houseCusps.twelfth
        XCTAssert(house.sign == Zodiac.gemini)
        XCTAssert(27 == Int32(house.degree))
        XCTAssert(29 == Int32(house.minute))
        XCTAssert(38 == Int32(house.second))
    }
}
