import XCTest
@testable import SwissEphemeris

// NOTE: This often crashes with a memory error. Commenting out for now
// You can run the tests individually
final class FixedStarsTests: XCTestCase {
	
	override func setUpWithError() throws {
		JPLFileManager.setEphemerisPath()
	}
/*
    static var date: Date {
        let dob = "1987-10-30 08:42:00 -0800"
        let d = Date(fromString: dob)!
        return d
    }

    func testGalacticCenter() {
		let galacticCenter = Coordinate(body: FixedStar.galacticCenter.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(galacticCenter.formatted, "26 Degrees Sagittarius ♐︎ 40' 39''")
	}
	
	func testAldebaran() {
		let aldebaran = Coordinate(body: FixedStar.aldebaran.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(aldebaran.formatted, "9 Degrees Gemini ♊︎ 37' 24''")
	}

	func testAntares() {
		let antares = Coordinate(body: FixedStar.antares.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(antares.formatted, "9 Degrees Sagittarius ♐︎ 35' 13''")
	}

	func testRegulus() {
		let regulus = Coordinate(body: FixedStar.regulus.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(regulus.formatted, "29 Degrees Leo ♌︎ 39' 26''")
	}

	func testSirius() {
		let sirius = Coordinate(body: FixedStar.sirius.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(sirius.formatted, "13 Degrees Cancer ♋︎ 55' 0''")
	}

	func testSpica() {
		let spica = Coordinate(body: FixedStar.spica.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(spica.formatted, "23 Degrees Libra ♎︎ 39' 56''")
	}

	func testAlgol() {
		let algol = Coordinate(body: FixedStar.algol.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(algol.formatted, "26 Degrees Taurus ♉︎ 0' 12''")
	}

	func testRigel() {
		let rigel = Coordinate(body: FixedStar.rigel.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(rigel.formatted, "16 Degrees Gemini ♊︎ 39' 51''")
	}

	func testAltair() {
		let altair = Coordinate(body: FixedStar.altair.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(altair.formatted, "1 Degrees Aquarius ♒︎ 36' 12''")
	}

	func testCapella() {
		let capella = Coordinate(body: FixedStar.capella.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(capella.formatted, "21 Degrees Gemini ♊︎ 41' 30''")
	}

	func testArcturus() {
		let arcturus = Coordinate(body: FixedStar.arcturus.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(arcturus.formatted, "24 Degrees Libra ♎︎ 3' 24''")
	}

	func testProcyon() {
		let procyon = Coordinate(body: FixedStar.procyon.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(procyon.formatted, "25 Degrees Cancer ♋︎ 37' 6''")
	}

	func testCastor() {
		let castor = Coordinate(body: FixedStar.castor.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(castor.formatted, "20 Degrees Cancer ♋︎ 4' 19''")
	}

	func testPollux() {
		let pollux = Coordinate(body: FixedStar.pollux.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(pollux.formatted, "23 Degrees Cancer ♋︎ 2' 55''")
	}

	func testBetelgeuse() {
		let betelgeuse = Coordinate(body: FixedStar.betelgeuse.celestialObject, date: FixedStarsTests.date)
		XCTAssertEqual(betelgeuse.formatted, "28 Degrees Gemini ♊︎ 35' 16''")
	}
*/
}
