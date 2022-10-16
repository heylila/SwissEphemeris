//
//  ColumbiaTransits.swift
//  
//
//  Created by Sam Krishna on 10/16/22.
//

import XCTest
@testable import SwissEphemeris

final class ColumbiaTransits: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        let dob = "1972-10-29 17:00:00 -0600"
        let dobDate = Date(fromString: dob, format: .cocoaDateTime)!
        return dobDate
    }

    static var chart: BirthChart {
        let lat: Double = 38.9517053
        let long: Double = -92.3340724
        return BirthChart(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }


}
