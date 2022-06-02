//
//  LouisvilleErrorTests.swift
//  
//
//  Created by Sam Krishna on 5/4/22.
//

import XCTest
@testable import SwissEphemeris
import CSwissEphemeris

enum DateError : Error {
    case componentsError(String)
}

class LouisvilleErrorTests: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    static var birthDate: Date {
        return Date(fromString: "1951-02-02 08:34:00 -0600", format: .cocoaDateTime)!
    }

    static var julianBirthDate: Date {
        let julianDouble = birthDate.julianDate()
        return Date(timeIntervalSince1970: julianDouble)
    }

    func testExample() throws {
        let lat = 38.2526647
        let lng = -85.7584557

        let jdate = LouisvilleErrorTests.julianBirthDate
        let cusps = HouseCusps(date: jdate, latitude: lat, longitude: lng, houseSystem: .placidus)
        print("cusps = \(cusps)")
    }
}
