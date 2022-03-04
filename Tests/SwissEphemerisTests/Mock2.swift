//
//  File.swift
//  
//
//  Created by Sam Krishna on 3/3/22.
//

import Foundation
import XCTest

@testable import SwissEphemeris

struct Mock2 {

    static var date: Date {
        let dob = "1983-03-17T09:45:00-0500"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from:dob)!
    }

    static func makeHouses() -> HouseCusps {
        /// Cleveland, Ohio, USA
        let latitude: Double = 41.505550
        let longitude: Double = -81.691498
        return HouseCusps(date: Mock.date, latitude: latitude, longitude: longitude, houseSystem: .placidus)
    }

    static func date(year: Int,
                     month: Int,
                     day: Int,
                     hour: Int,
                     minute: Int,
                     second: Int) -> Date? {
        let components = DateComponents(calendar: Calendar.init(identifier: .gregorian),
                                        year: year,
                                        month: month,
                                        day: day,
                                        hour: hour,
                                        minute: minute,
                                        second: second)
        return Calendar.current.date(from: components)
    }

    static func date(from timestamp: String) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return try XCTUnwrap(dateFormatter.date(from:timestamp))
    }
}
