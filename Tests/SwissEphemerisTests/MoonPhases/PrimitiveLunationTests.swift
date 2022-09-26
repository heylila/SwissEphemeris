//
//  SeptemberPhases.swift
//  
//
//  Created by Sam Krishna on 9/18/22.
//

import XCTest
@testable import SwissEphemeris

final class SeptemberPhases: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    func testNewMoonInAugust2022() throws {
        let newMoonDate = Date(fromString: "2022-08-27 01:17:00 -0700")!
        let lunation = Lunation(date: newMoonDate)
        XCTAssert(lunation.phase == .new)
    }

    func testFindQ1Moon() throws {
//        let newMoonDate = Date(fromString: "2022-09-03 10:07:00 -0700")!
//        let endMoonDate = newMoonDate.offset(.hour, value: 2)!
//
//        let moonPositions = BodiesRequest(body: Planet.moon).fetch(start: newMoonDate, end: endMoonDate, interval: 60.0)
//
//        let firstQuarters = moonPositions.filter { now in
//            let l = Lunation(date: now.date)
//            return (0.2499...0.2501).contains(l.percentage)
//        }
//
//        for quarter in moonPositions {
//            let l = Lunation(date: quarter.date)
//            print("\(l.date.toString(format: .cocoaDateTime)!) and longitude: \(preciseRound(quarter.longitude, precision: .thousandths)) and percentage: \(l.percentage)")
//        }

        let preQ1Date = Date(fromString: "2022-09-03 11:06:00 -0700")!
        let preQ1 = Lunation(date: preQ1Date)
        print("percentage = \(preQ1.percentage)")



        let q1Date = Date(fromString: "2022-09-03 11:07:00 -0700")!
        let q1 = Lunation(date: q1Date)
        print("percentage = \(q1.percentage)")
    }

}
