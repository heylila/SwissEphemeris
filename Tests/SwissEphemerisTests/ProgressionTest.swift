//
//  ProgressionTest.swift
//  
//
//  Created by Sam Krishna on 4/4/22.
//

import XCTest
import SwissEphemeris

class ProgressionTest: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        let dob = "1977-05-21 13:57:00 -0700"
        let dobDate = Date(fromString: dob, format: .cocoaDateTime)!
        return dobDate
    }

    static var houseSystem: HouseCusps {
        let lat: Double = 32.71667
        let long: Double = -117.15
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    func testExample() throws {
        let houseSystem = ProgressionTest.houseSystem
        // Remember: the value you see for the Asc is the # of degrees from 0 degrees Aries
        print("pure asc = \(houseSystem.ascendent)")
        print("1st house = \(houseSystem.ascendent.formatted)")
        print("2nd house = \(houseSystem.second.formatted)")
        print("3rd house = \(houseSystem.third.formatted)")
        print("4th house = \(houseSystem.fourth.formatted)")
        print("5th house = \(houseSystem.fifth.formatted)")
        print("6th house = \(houseSystem.sixth.formatted)")
        print("7th house = \(houseSystem.seventh.formatted)")
        print("8th house = \(houseSystem.eighth.formatted)")
        print("9th house = \(houseSystem.ninth.formatted)")
        print("10th house = \(houseSystem.tenth.formatted)")
        print("11th house = \(houseSystem.eleventh.formatted)")
        print("12th house = \(houseSystem.twelfth.formatted)")
    }

}
