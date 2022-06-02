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
    // Date: 1908-05-05 09:30:00 +0010 (UTC)

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        return Date(fromString: "1908-05-05 09:20:39 +0000", format: .cocoaDateTime, timeZone: .utc)!
    }

    static var houseSystem: HouseCusps {
        let lat = 48.956682
        let long = 4.363073
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    static var planets: [String : Coordinate<Planet> ] {
        return [
            Planet.sun.formatted : Coordinate(body: Planet.sun, date: birthDate),
            Planet.moon.formatted : Coordinate(body: .moon, date: birthDate),
            Planet.mercury.formatted : Coordinate(body: .mercury, date: birthDate),
            Planet.venus.formatted : Coordinate(body: .venus, date: birthDate),
            Planet.mars.formatted : Coordinate(body: .mars, date: birthDate),
            Planet.jupiter.formatted : Coordinate(body: .jupiter, date: birthDate),
            Planet.saturn.formatted : Coordinate(body: .saturn, date: birthDate),
            Planet.uranus.formatted : Coordinate(body: .uranus, date: birthDate),
            Planet.neptune.formatted : Coordinate(body: .neptune, date: birthDate),
            Planet.pluto.formatted : Coordinate(body: .pluto, date: birthDate)
        ]
    }

    func testSun() throws {
        let sun = Coordinate(body: Planet.sun, date: ChalonsTests.birthDate)
        XCTAssert(sun.sign == Zodiac.taurus)
        XCTAssert(14 == Int32(sun.degree))
        XCTAssert(27 == Int32(sun.minute))
        XCTAssert(49 == Int32(sun.second))
        XCTAssert(0 == Int32(sun.latitude))
    }

    func testMoon() throws {
        let moon = Coordinate(body: Planet.moon, date: ChalonsTests.birthDate)
        XCTAssert(moon.sign == Zodiac.cancer)
        XCTAssert(10 == Int32(moon.degree))
        XCTAssert(41 == Int32(moon.minute))
        XCTAssert(13 == Int32(moon.second))
        XCTAssert(0 == Int32(moon.latitude))
    }

    func testMercury() throws {
        let mercury = Coordinate(body: Planet.mercury, date: ChalonsTests.birthDate)
        XCTAssert(mercury.sign == Zodiac.taurus)
        XCTAssert(11 == Int32(mercury.degree))
        XCTAssert(38 == Int32(mercury.minute))
        XCTAssert(49 == Int32(mercury.second))
        XCTAssert(0 == Int32(mercury.latitude))
    }

    func testVenus() throws {
        let venus = Coordinate(body: Planet.venus, date: ChalonsTests.birthDate)
        XCTAssert(venus.sign == Zodiac.gemini)
        XCTAssert(29 == Int32(venus.degree))
        XCTAssert(41 == Int32(venus.minute))
        XCTAssert(13 == Int32(venus.second))
        XCTAssert(3 == Int32(venus.latitude))
    }

    func testMars() throws {
        let mars = Coordinate(body: Planet.mars, date: ChalonsTests.birthDate)
        XCTAssert(mars.sign == Zodiac.gemini)
        XCTAssert(18 == Int32(mars.degree))
        XCTAssert(44 == Int32(mars.minute))
        XCTAssert(32 == Int32(mars.second))
        XCTAssert(0 == Int32(mars.latitude))
    }

    func testJupiter() throws {
        let jupiter = Coordinate(body: Planet.jupiter, date: ChalonsTests.birthDate)
        XCTAssert(jupiter.sign == Zodiac.leo)
        XCTAssert(5 == Int32(jupiter.degree))
        XCTAssert(29 == Int32(jupiter.minute))
        XCTAssert(37 == round(jupiter.second))
        XCTAssert(0 == Int32(jupiter.latitude))
    }

    func testSaturn() throws {
        let saturn = Coordinate(body: Planet.saturn, date: ChalonsTests.birthDate)
        XCTAssert(saturn.sign == Zodiac.aries)
        XCTAssert(5 == Int32(saturn.degree))
        XCTAssert(32 == Int32(saturn.minute))
        XCTAssert(52 == Int32(saturn.second))
        XCTAssert(-2 == Int32(saturn.latitude))
    }

    func testUranus() throws {
        let uranus = Coordinate(body: Planet.uranus, date: ChalonsTests.birthDate)
        XCTAssert(uranus.sign == Zodiac.capricorn)
        XCTAssert(16 == Int32(uranus.degree))
        XCTAssert(49 == Int32(uranus.minute))
        XCTAssert(40 == Int32(uranus.second))
        XCTAssert(0 == Int32(uranus.latitude))
    }

    func testNeptune() throws {
        let neptune = Coordinate(body: Planet.neptune, date: ChalonsTests.birthDate)
        XCTAssert(neptune.sign == Zodiac.cancer)
        XCTAssert(12 == Int32(neptune.degree))
        XCTAssert(34 == Int32(neptune.minute))
        XCTAssert(24 == Int32(neptune.second))
        XCTAssert(0 == Int32(neptune.latitude))
    }

    func testPluto() throws {
        let pluto = Coordinate(body: Planet.pluto, date: ChalonsTests.birthDate)
        XCTAssert(pluto.sign == Zodiac.gemini)
        XCTAssert(23 == Int32(pluto.degree))
        XCTAssert(22 == Int32(pluto.minute))
        XCTAssert(27 == Int32(pluto.second))
        XCTAssert(-7 == Int32(pluto.latitude))
    }

    func testChiron() throws {
        let chiron = Coordinate(body: Asteroid.chiron, date: ChalonsTests.birthDate)
        XCTAssert(chiron.sign == Zodiac.aquarius)
        XCTAssert(23 == Int32(chiron.degree))
        XCTAssert(6 == Int32(chiron.minute))
        XCTAssert(39 == Int32(chiron.second))
        XCTAssert(6 == Int32(chiron.latitude))
    }

}
