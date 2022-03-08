import XCTest
@testable import SwissEphemeris

final class LilaCelestialBodyTests: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    func testSunZodiacCoordinate() {
        // 12.14.2019 13:39 UT/GMT
        let date = Date(timeIntervalSince1970: 598023482.487818)
        let sunCoordinate = Coordinate<Planet>(body: .sun, date: date)
        XCTAssertEqual(sunCoordinate.value, 261.7804948994796)
        XCTAssertEqual(sunCoordinate.sign, .sagittarius)
        XCTAssertEqual(sunCoordinate.formatted, "21 Degrees Sagittarius ♐︎ 46' 49''")
        XCTAssertEqual(Int(sunCoordinate.degree), 21)
        XCTAssertEqual(Int(sunCoordinate.minute), 46)
        XCTAssertEqual(Int(sunCoordinate.second), 49)
    }

    func testMoonSiderealCoordinate() {
        let moonCoordinate = SiderealCoordinate(coordinate: Coordinate<Planet>(body: .moon, date: LilaMock.date),
                                                ayanamshaValue: Ayanamsha()(for: LilaMock.date))
        XCTAssertEqual(Int(moonCoordinate.value), 5)
        XCTAssertEqual(moonCoordinate.sign, .aries)
        XCTAssertEqual(moonCoordinate.formatted, "5 Degrees Aries ♈︎ 51\' 45\'\'")
        XCTAssertEqual(Int(moonCoordinate.degree), 5)
        XCTAssertEqual(Int(moonCoordinate.minute), 51)
        XCTAssertEqual(Int(moonCoordinate.second), 45)
    }

    func testAstroids() throws {
        let date = try XCTUnwrap(LilaMock.date(from: "2021-03-01T12:31:00-0800"))
        let chiron = Coordinate<Astroid>(body: .chiron, date: date)
        XCTAssertEqual(Int(chiron.degree), 7)
        XCTAssertEqual(chiron.sign, .aries)
        let pholus = Coordinate<Astroid>(body: .pholus, date: date)
        XCTAssertEqual(Int(pholus.degree), 5)
        XCTAssertEqual(pholus.sign, .capricorn)
        let ceres = Coordinate<Astroid>(body: .ceres, date: date)
        XCTAssertEqual(Int(ceres.degree), 3)
        XCTAssertEqual(ceres.sign, .aries)
        let pallas = Coordinate<Astroid>(body: .pallas, date: date)
        XCTAssertEqual(Int(pallas.degree), 28)
        XCTAssertEqual(pallas.sign, .aquarius)
        let juno = Coordinate<Astroid>(body: .juno, date: date)
        XCTAssertEqual(Int(juno.degree), 19)
        XCTAssertEqual(juno.sign, .sagittarius)
        let vesta = Coordinate<Astroid>(body: .vesta, date: date)
        XCTAssertEqual(Int(vesta.degree), 15)
        XCTAssertEqual(vesta.sign, .virgo)
    }

    func testLunarNodes() throws {
        let date = try XCTUnwrap(LilaMock.date(year: 2121, month: 1, day: 1, hour: 1, minute: 1, second: 1))
        let trueNode = Coordinate<LunarNode>(body: .trueNode, date: date)
        XCTAssertEqual(Int(trueNode.degree), 3)
        XCTAssertEqual(trueNode.sign, .aquarius)
        let meanNode = Coordinate<LunarNode>(body: .meanNode, date: date)
        XCTAssertEqual(Int(meanNode.degree), 4)
        XCTAssertEqual(meanNode.sign, .aquarius)
    }

    func testPlanets() {
        for (index, planet) in Planet.allCases.enumerated() {
            switch index {
            case 0:
                XCTAssertEqual(planet.formatted, "☉ Sun")
                XCTAssertEqual(planet.symbol, "☉")
            case 1:
                XCTAssertEqual(planet.formatted, "☾ Moon")
                XCTAssertEqual(planet.symbol, "☾")
            case 2:
                XCTAssertEqual(planet.formatted, "☿ Mercury")
                XCTAssertEqual(planet.symbol, "☿")
            case 3:
                XCTAssertEqual(planet.formatted, "♀ Venus")
                XCTAssertEqual(planet.symbol, "♀")
            case 4:
                XCTAssertEqual(planet.formatted, "♂️Mars")
                XCTAssertEqual(planet.symbol, "♂︎")
            case 5:
                XCTAssertEqual(planet.formatted, "♃ Jupiter")
                XCTAssertEqual(planet.symbol, "♃")
            case 6:
                XCTAssertEqual(planet.formatted, "♄ Saturn")
                XCTAssertEqual(planet.symbol, "♄")
            case 7:
                XCTAssertEqual(planet.formatted, "♅ Uranus")
                XCTAssertEqual(planet.symbol, "♅")
            case 8:
                XCTAssertEqual(planet.formatted, "♆ Neptune")
                XCTAssertEqual(planet.symbol, "♆")
            case 9:
                XCTAssertEqual(planet.formatted, "♇ Pluto")
                XCTAssertEqual(planet.symbol, "♇")
            default:
                XCTFail("Failed because there are planets that not tested")
            }
        }
    }

    func testZodiac() {
        for (index, sign) in Zodiac.allCases.enumerated() {
            switch index {
            case 0:
                XCTAssertEqual(sign.formatted, "Aries ♈︎")
                XCTAssertEqual(sign.symbol, "♈︎")
            case 1:
                XCTAssertEqual(sign.formatted, "Taurus ♉︎")
                XCTAssertEqual(sign.symbol, "♉︎")
            case 2:
                XCTAssertEqual(sign.formatted, "Gemini ♊︎")
                XCTAssertEqual(sign.symbol, "♊︎")
            case 3:
                XCTAssertEqual(sign.formatted, "Cancer ♋︎")
                XCTAssertEqual(sign.symbol, "♋︎")
            case 4:
                XCTAssertEqual(sign.formatted, "Leo ♌︎")
                XCTAssertEqual(sign.symbol, "♌︎")
            case 5:
                XCTAssertEqual(sign.formatted, "Virgo ♍︎")
                XCTAssertEqual(sign.symbol, "♍︎")
            case 6:
                XCTAssertEqual(sign.formatted, "Libra ♎︎")
                XCTAssertEqual(sign.symbol, "♎︎")
            case 7:
                XCTAssertEqual(sign.formatted, "Scorpio ♏︎")
                XCTAssertEqual(sign.symbol, "♏︎")
            case 8:
                XCTAssertEqual(sign.formatted, "Sagittarius ♐︎")
                XCTAssertEqual(sign.symbol, "♐︎")
            case 9:
                XCTAssertEqual(sign.formatted, "Capricorn ♑︎")
                XCTAssertEqual(sign.symbol, "♑︎")
            case 10:
                XCTAssertEqual(sign.formatted, "Aquarius ♒︎")
                XCTAssertEqual(sign.symbol, "♒︎")
            case 11:
                XCTAssertEqual(sign.formatted, "Pisces ♓︎")
                XCTAssertEqual(sign.symbol, "♓︎")
            default:
                XCTFail("Failed because there are signs that are not tested")
            }
        }
        XCTAssertNil(Zodiac(rawValue: 12))
    }

    func testAscendent() {
        let houseSystem = LilaMock.makeHouses()
        // Ascendent
        let ascCoordinate = houseSystem.ascendent
        XCTAssertEqual(ascCoordinate.sign, Zodiac.gemini)
        XCTAssertEqual(ascCoordinate.formatted, "6 Degrees Gemini ♊︎ 16\' 30\'\'")

        // MC
        let mc = houseSystem.midHeaven
        XCTAssertEqual(mc.sign, Zodiac.aquarius)
    }

    func testHouses() {
        let houseSystem = LilaMock.makeHouses()
        /// House Cusps
        XCTAssertEqual(houseSystem.first.sign, Zodiac.gemini)
        XCTAssertEqual(houseSystem.second.sign, Zodiac.gemini)
        XCTAssertEqual(houseSystem.third.sign, Zodiac.cancer)
        XCTAssertEqual(houseSystem.fourth.sign, Zodiac.leo)
        XCTAssertEqual(houseSystem.fifth.sign, Zodiac.virgo)
        XCTAssertEqual(houseSystem.sixth.sign, Zodiac.libra)
        XCTAssertEqual(houseSystem.seventh.sign, Zodiac.sagittarius)
        XCTAssertEqual(houseSystem.eighth.sign, Zodiac.sagittarius)
        XCTAssertEqual(houseSystem.ninth.sign, Zodiac.capricorn)
        XCTAssertEqual(houseSystem.tenth.sign, Zodiac.aquarius)
        XCTAssertEqual(houseSystem.eleventh.sign, Zodiac.pisces)
        XCTAssertEqual(houseSystem.twelfth.sign, Zodiac.aries)
    }

    func testSigns() {
        let houseSystem = LilaMock.makeHouses()

        /// Initial Sign angles
        XCTAssertEqual(houseSystem.aries.degree, 293.725)
        XCTAssertEqual(houseSystem.taurus.degree, 323.725)
        XCTAssertEqual(houseSystem.gemini.degree, 353.725)
        XCTAssertEqual(houseSystem.cancer.degree, 23.725)
        XCTAssertEqual(houseSystem.leo.degree, 53.725)
        XCTAssertEqual(houseSystem.virgo.degree, 83.725)
        XCTAssertEqual(houseSystem.libra.degree, 113.725)
        XCTAssertEqual(houseSystem.scorpio.degree, 143.725)
        XCTAssertEqual(houseSystem.sagittarius.degree, 173.725)
        XCTAssertEqual(houseSystem.capricorn.degree, 203.725)
        XCTAssertEqual(houseSystem.aquarius.degree, 233.725)
        XCTAssertEqual(houseSystem.pisces.degree, 263.725)
    }

    let conjunctionOrb = 11.0
    let oppositionOrb = 9.0
    let squareOrb = 9.0
    let trineOrb = 7.0
    let sextileOrb = 7.0

    func testSolarAspects() {
        var aspect = Aspect(pair: Pair<Planet, Planet>(a: .sun, b: .mercury), date: LilaMock.date, orb: conjunctionOrb)
        XCTAssertEqual(aspect?.remainder, 8.29)
        XCTAssertEqual(aspect, .conjunction(8.29))

        // Just to prove that Sun-Mars have no usable aspect
        aspect = Aspect(pair: Pair<Planet, Planet>(a: .sun, b: .mars), date: LilaMock.date, orb: conjunctionOrb)
        XCTAssertNil(aspect)

        aspect = Aspect(pair: Pair<Planet, Planet>(a: .sun, b: .neptune), date: LilaMock.date, orb: squareOrb)
        XCTAssertEqual(aspect?.remainder, -2.73)
        XCTAssertEqual(aspect, .square(-2.73))

        aspect = Aspect(pair: Pair<Planet, LunarNode>(a: .sun, b: .trueNode), date: LilaMock.date, orb: squareOrb)
        XCTAssertEqual(aspect?.remainder, 3.27)
        XCTAssertEqual(aspect, .square(3.27))
    }

    func testLunarAspects() {
        // Moon conjunction Venus
        var aspect = Aspect(pair: Pair<Planet, Planet>(a: .moon, b: .venus), date: LilaMock.date, orb: conjunctionOrb)
        XCTAssertEqual(aspect?.remainder, 2.55)
        XCTAssertEqual(aspect, .conjunction(2.55))

        // Failed Moon conjuction Mercury
        aspect = Aspect(pair: Pair<Planet, Planet>(a: .moon, b: .mercury), date: LilaMock.date, orb: conjunctionOrb)
        XCTAssertNil(aspect)

        // Moon opposes Saturn
        aspect = Aspect(pair: Pair<Planet, Planet>(a: .moon, b: .saturn), date: LilaMock.date, orb: oppositionOrb)
        XCTAssertEqual(aspect?.remainder, -3.15)
        XCTAssertEqual(aspect, .opposition(-3.15))

        // Moon trine Neptune
        aspect = Aspect(pair: Pair<Planet, Planet>(a: .moon, b: .neptune), date: LilaMock.date, orb: trineOrb)
        XCTAssertEqual(aspect?.remainder, 1.19)
        XCTAssertEqual(aspect, .trine(1.19))

        // Moon oppoes Pluto
        aspect = Aspect(pair: Pair<Planet, Planet>(a: .moon, b: .pluto), date: LilaMock.date, orb: oppositionOrb)
        XCTAssertEqual(aspect?.remainder, -1.38)
        XCTAssertEqual(aspect, .opposition(-1.38))

        // Moon sextile North Node
        aspect = Aspect(pair: Pair<Planet, LunarNode>(a: .moon, b: .trueNode), date: LilaMock.date, orb: sextileOrb)
        XCTAssertEqual(aspect?.remainder, -0.66)
        XCTAssertEqual(aspect, .sextile(-0.66))
    }

    func testMercuryAspects() {
        // Mercury square Jupiter
        var aspect = Aspect(pair: Pair<Planet, Planet>(a: .mercury, b: .jupiter), date: LilaMock.date, orb: squareOrb)
        XCTAssertEqual(aspect?.remainder, 7.39)
        XCTAssertEqual(aspect, .square(7.39))

        // Mercury square Uranus
        aspect = Aspect(pair: Pair<Planet, Planet>(a: .mercury, b: .uranus), date: LilaMock.date, orb: squareOrb)
        XCTAssertNil(aspect)

        // Mercury sextile Chiron
        aspect = Aspect(pair: Pair<Planet, Astroid>(a: .mercury, b: .chiron), date: LilaMock.date, orb: sextileOrb)
        XCTAssertEqual(aspect?.remainder, 5.59)
        XCTAssertEqual(aspect, .sextile(5.59))
    }

    func testVenusAspects() {
        // Venus opposes Saturn
        var aspect = Aspect(pair: Pair<Planet, Planet>(a: .venus, b: .saturn), date: LilaMock.date, orb: oppositionOrb)
        XCTAssertEqual(aspect?.remainder, -5.7)
        XCTAssertEqual(aspect, .opposition(-5.7))

        // Venus trine Neptune
        aspect = Aspect(pair: Pair<Planet, Planet>(a: .venus, b: .neptune), date: LilaMock.date, orb: trineOrb)
        XCTAssertEqual(aspect?.remainder, -1.35)
        XCTAssertEqual(aspect, .trine(-1.35))

        // Venus opposes Pluto
        aspect = Aspect(pair: Pair<Planet, Planet>(a: .venus, b: .pluto), date: LilaMock.date, orb: oppositionOrb)
        XCTAssertEqual(aspect?.remainder, -1.17)
        XCTAssertEqual(aspect, .opposition(-1.17))

        // Venus sextile True Node
        aspect = Aspect(pair: Pair<Planet, LunarNode>(a: .venus, b: .trueNode), date: LilaMock.date, orb: sextileOrb)
        XCTAssertEqual(aspect?.remainder, 1.89)
        XCTAssertEqual(aspect, .sextile(1.89))
    }

    func testMarsAspects() {
        // Mars trine Jupiter
        var aspect = Aspect(pair: Pair<Planet, Planet>(a: .mars, b: .jupiter), date: LilaMock.date, orb: trineOrb)
        XCTAssertEqual(aspect?.remainder, 5.0)
        XCTAssertEqual(aspect, .trine(5.0))

        // Mars trine Uranus
        aspect = Aspect(pair: Pair<Planet, Planet>(a: .mars, b: .uranus), date: LilaMock.date, orb: trineOrb)
        XCTAssertEqual(aspect?.remainder, 6.65)
        XCTAssertEqual(aspect, .trine(6.65))
    }

    func testJupiterAspects() {
        // Jupiter conjuncts Uranus
        let aspect = Aspect(pair: Pair<Planet, Planet>(a: .jupiter, b: .jupiter), date: LilaMock.date, orb: conjunctionOrb)
        XCTAssertEqual(aspect?.remainder, 0.0)
        XCTAssertEqual(aspect, .conjunction(0.0))
    }

    func testSaturnAspects() {
        // Saturn sextile Neptune
        var aspect = Aspect(pair: Pair<Planet, Planet>(a: .saturn, b: .neptune), date: LilaMock.date, orb: sextileOrb)
        XCTAssertEqual(aspect?.remainder, -4.35)
        XCTAssertEqual(aspect, .sextile(-4.35))

        // Saturn conjunction Pluto
        aspect = Aspect(pair: Pair<Planet, Planet>(a: .saturn, b: .pluto), date: LilaMock.date, orb: conjunctionOrb)
        XCTAssertEqual(aspect?.remainder, 4.53)
        XCTAssertEqual(aspect, .conjunction(4.53))

        // Saturn trine True Node
        aspect = Aspect(pair: Pair<Planet, LunarNode>(a: .saturn, b: .trueNode), date: LilaMock.date, orb: trineOrb)
        XCTAssertEqual(aspect?.remainder, 3.81)
        XCTAssertEqual(aspect, .trine(3.81))
    }

    func testNeptuneAspects() {
        // Neptune sextile Pluto
        var aspect = Aspect(pair: Pair<Planet, Planet>(a: .neptune, b: .pluto), date: LilaMock.date, orb: sextileOrb)
        XCTAssertEqual(aspect?.remainder, 0.18)
        XCTAssertEqual(aspect, .sextile(0.18))

        // Neptune opposes True Node
        aspect = Aspect(pair: Pair<Planet, LunarNode>(a: .neptune, b: .trueNode), date: LilaMock.date, orb: oppositionOrb)
        XCTAssertEqual(aspect?.remainder, -0.54)
        XCTAssertEqual(aspect, .opposition(-0.54))
    }

    func testPlutoAspects() {
        // Pluto trine True Node
        let aspect = Aspect(pair: Pair<Planet, LunarNode>(a: .pluto, b: .trueNode), date: LilaMock.date, orb: trineOrb)
        XCTAssertEqual(aspect?.remainder, -0.72)
        XCTAssertEqual(aspect, .trine(-0.72))
    }

    func testAspectCount() {
        let sunAspects = Planet.allCases.compactMap {
            Aspect(pair: Pair<Planet, Planet>(a: .sun, b: $0),date: LilaMock.date, orb: 10)
        }
        XCTAssertEqual(sunAspects.count, 3)
        let moonAspects = Planet.allCases.compactMap {
            Aspect(pair: Pair<Planet, Planet>(a: .moon, b: $0),date: LilaMock.date, orb: 10)
        }
        XCTAssertEqual(moonAspects.count, 5)
        let mercuryAspects = Planet.allCases.compactMap {
            Aspect(pair: Pair<Planet, Planet>(a: .mercury, b: $0),date: LilaMock.date, orb: 8)
        }
        XCTAssertEqual(mercuryAspects.count, 2)
    }

    func testPlanetsOnAscendent() {
        let houseSystem = LilaMock.makeHouses()
        let ascendent = houseSystem.ascendent
        let aspects = Planet.allCases.compactMap {
            Aspect(a: ascendent.value,
                   b: Coordinate<Planet>(body: $0, date: LilaMock.date).value,
                   orb: 10)
        }
        XCTAssertEqual(aspects.compactMap { $0 }.count, 4)
    }

    func testPlanetaryStation() {
        XCTAssertEqual(Station<Planet>(coordinate: Coordinate(body: .sun, date: LilaMock.date)), .direct)
        XCTAssertEqual(Station<Planet>(coordinate: Coordinate(body: .mars, date: LilaMock.date)), .direct)
        XCTAssertEqual(Station<Planet>(coordinate: Coordinate(body: .saturn, date: LilaMock.date)), .retrograde)
        XCTAssertEqual(Station<Planet>(coordinate: Coordinate(body: .pluto, date: LilaMock.date)), .retrograde)
    }

    func testAyanamsha() throws {
        let date = try XCTUnwrap(LilaMock.date(from: "2021-03-09T12:31:00-0800"))
        let ayanamsha = Ayanamsha()(for: date)
        XCTAssertEqual((ayanamsha * 100).rounded() / 100, 25.04)
    }

    func testPlanetRisingTime() throws {
        let timestamp = "2021-03-14"
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/Los_Angeles")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = try XCTUnwrap(dateFormatter.date(from: timestamp))
        let sunriseSantaCruz = RiseTime<Planet>(
            date: date,
            body: .sun,
            longitude: -122.0297222,
            latitude: 36.9741667,
            altitude: 0
        )

        XCTAssertEqual(sunriseSantaCruz.date?.description, "2021-03-14 14:19:44 +0000")
        let dateB = try XCTUnwrap(dateFormatter.date(from: "2021-03-15"))
        let moonRiseNYC = RiseTime<Planet>(
            date: dateB,
            body: .moon,
            longitude: -73.935242,
            latitude: 40.730610,
            altitude: 0
        )
        XCTAssertEqual(moonRiseNYC.date?.description, "2021-03-15 12:25:55 +0000")
    }

    func testPlanetSettingTime() throws {
        let timestamp = "2021-03-15"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = try XCTUnwrap(dateFormatter.date(from: timestamp))
        let moonSet = SetTime<Planet>(
            date: date,
            body: .moon,
            longitude: 13.41053,
            latitude: 52.52437
        )
        XCTAssertEqual(moonSet.date?.description, "2021-03-15 19:25:58 +0000")
        let dateB = try XCTUnwrap(dateFormatter.date(from: "2021-03-16"))
        let sunsetTokyo = SetTime<Planet>(
            date: dateB,
            body: .sun,
            longitude: 139.69171,
            latitude: 35.6895
        )
        XCTAssertEqual(sunsetTokyo.date?.description, "2021-03-16 08:49:34 +0000")
    }

    func testLunarPhase() throws {
        let date = try LilaMock.date(from: "2021-03-21T11:11:00-0000")
        let lunation = Lunation(date: date)
        XCTAssertEqual((lunation.percentage * 100).rounded() / 100, 0.49)
        XCTAssertEqual(lunation.phase, .waxingCrescent)
        var lunationB = Lunation(date: try LilaMock.date(from: "2021-04-12T01:11:00-0001"))
        XCTAssertEqual((lunationB.percentage * 100).rounded() / 100, 0)
        XCTAssertEqual(lunationB.phase, .new)
        let interval: TimeInterval = 60 * 60 * 24
        var count = 0
        repeat {
            lunationB = Lunation(date: lunationB.date.addingTimeInterval(interval))
            count += 1
        } while lunationB.phase != .full
        // Count from new to full
        XCTAssertEqual(count, 14)
        repeat {
            lunationB = Lunation(date: lunationB.date.addingTimeInterval(interval))
            count += 1
        } while lunationB.phase != .new
        // Count from full to new
        XCTAssertEqual(count, 29)
    }

    func testLunarMansion() throws {
        var date = try LilaMock.date(from: "2021-04-12T01:11:00-0001")
        let interval: TimeInterval = 60 * 60 * 12
        var formatted = Set<String>()
        for _ in 0...56 {
            let moon = Coordinate<Planet>(body: .moon, date: date)
            formatted.insert(moon.lunarMansion.formatted)
            if #available(iOS 13.0, *) {
                date = date.advanced(by: interval)
            }
        }
        // Expect a unique description for each mansion.
        XCTAssertEqual(formatted.count, 28)
    }

    func testLunarScratch() {
        let natalSun = Coordinate(body: Planet.sun, date: LilaMock.date)

        // Find the current moon that matches the natalSun.longitude
        // Use two weeks in either direction of 2022-03-04 14:00:00 -0800 as a starting point
        // Use a predicate to figure out the first match within +/- 1° of the natalSun's longitude

        let date = Date(fromString: "2022-03-04 14:00:00 -0800", format: .cocoaDateTime)!
        let moon = Coordinate(body: Planet.moon, date: date)
        print("natalSun.long = \(natalSun.longitude)")
        print("moon.long = \(moon.longitude)")
        print("do we understand anything yet?")

        guard let start = date.offset(.day, value: -14) else { return }
        guard let end = date.offset(.day, value: 14) else { return }

        // Use the PlanetsRequest API to get this
        // Do it on a per-hour basis first

        let nearestHourMoonPosition = PlanetsRequest(body: .moon).fetch(start: start, end: end, interval: Double(60 * 60))
            .filter { abs($0.longitude - natalSun.longitude) < 1 }
            .min { lhs, rhs in
                return lhs.longitudeDelta(other: natalSun) < rhs.longitudeDelta(other: natalSun)
            }

        let detailDate = nearestHourMoonPosition!.date
        let minStart = detailDate.offset(.minute, value: -30)!
        let minEnd = detailDate.offset(.minute, value: 30)!

        // Then slice it to the per-minute basis next
        let nearestMinuteMoonPosition = PlanetsRequest(body: .moon).fetch(start: minStart, end: minEnd, interval: 60.0)
            .min { lhs, rhs in
                return lhs.longitudeDelta(other: natalSun) < rhs.longitudeDelta(other: natalSun)
            }

        let testDate = Date(fromString: "2022-03-03 18:34:00 +0000", format: .cocoaDateTime, timeZone: .utc)
        XCTAssertEqual(nearestMinuteMoonPosition?.date, testDate)
    }

    func testSiderealCoordinateEarlyAries() throws {
        let date = try LilaMock.date(from: "2021-03-25T01:11:00-0001")
        let sun = Coordinate<Planet>(body: .sun, date: date)
        XCTAssertEqual(sun.sign, .aries)
        let siderealSun = SiderealCoordinate(coordinate: sun)
        XCTAssertEqual(siderealSun.sign, .pisces)
    }

    static var allTests = [
        ("testSunZodiacCoordinate",testSunZodiacCoordinate,
         "testMoonSiderealCoordinate", testMoonSiderealCoordinate,
         "testPlanets", testPlanets,
         "testAstroids", testAstroids,
         "testZodiac", testZodiac,
         "testLunarNodes", testLunarNodes,
         "testAscendent", testAscendent,
         "testHouses", testHouses,
         "testSigns", testSigns,
         "testSolarAspects", testSolarAspects,
         "testLunarAspects", testLunarAspects,
         "testMercuryAspects", testMercuryAspects,
         "testVenusAspects", testVenusAspects,
         "testMarsAspects", testMarsAspects,
         "testJupiterAspects", testJupiterAspects,
         "testSaturnAspects", testSaturnAspects,
         "testNeptuneAspects", testNeptuneAspects,
         "testPlutoAspects", testPlutoAspects,
         "testPlanetaryStation", testPlanetaryStation,
         "testAyanamsha", testAyanamsha,
         "testPlanetRisingTime", testPlanetRisingTime,
         "testPlanetSettingTime", testPlanetSettingTime,
         "testLunarPhase", testLunarPhase,
         "testLunarMansion", testLunarMansion,
         "testLunarScratch", testLunarScratch,
         "testSiderealCoordinateEarlyAries", testSiderealCoordinateEarlyAries)
    ]
}
