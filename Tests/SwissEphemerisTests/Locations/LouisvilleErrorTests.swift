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

    func testTimeZone() throws {
        let birthDate = LouisvilleErrorTests.birthDate
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: birthDate)
        guard let year = comps.year,
              let month = comps.month,
              let day = comps.day,
              let hour = comps.hour,
              let minute = comps.minute else { throw DateError.componentsError("Couldn't get all the date components") }

        var pointer = UnsafeMutablePointer<Int32>.allocate(capacity: 5)
        let tzoffset = swe_utc_time_zone(Int32(year),
                                         Int32(month),
                                         Int32(day),
                                         Int32(hour),
                                         Int32(minute),
                                         0.0,
                                         -5.0,
                                         &pointer[0],
                                         &pointer[1],
                                         &pointer[2],
                                         &pointer[3],
                                         &pointer[4],
                                         nil)
    }
}
