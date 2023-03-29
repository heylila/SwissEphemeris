//
//  Cusp.swift
//  
//
//  Created by Vincent Smithers on 08.02.21.
//

import Foundation
import CSwissEphemeris

/// Models the point between two houses
public struct Cusp: Equatable, Comparable, Codable {

	/// The degree of the coordinate
	public let value: Double

    /// The name of the Cusp
    public let name: String

    /// The number of the Cusp (1 = "first", 2 = "second", etc up to 12)
    public let number: Int

    /// The date for the Cusp's creation
    private let date: Date

	/// Creates a `Cusp`.
	/// - Parameter value: The longitudinal degree to set.
    /// - Parameter name: The "name" of the cusp ("first", "ascendant", "midheaven", etc)
    /// - Parameter number: The ordinal number of the Cusp (1, 2, 3, ...)
    /// - Parameter date: The date the Cusp was created (should be the same as its House System)
    public init(value: Double, name: String, number: Int, date: Date = Date()) {
		self.value = value
        self.name = name
        self.number = number
        self.date = date
	}

    static public func < (lhs: Cusp, rhs: Cusp) -> Bool {
        return lhs.value < rhs.value
    }

    static public func == (lhs: Cusp, rhs: Cusp) -> Bool {
        return lhs.value == rhs.value
    }

    func eclipticToEquatorial(longitude: Double, obliquity: Double) -> (rightAscension: Double, declination: Double) {
        let radLongitude = longitude * Double.pi / 180
        let radObliquity = obliquity * Double.pi / 180

        let ra = atan2(cos(radObliquity) * sin(radLongitude), cos(radLongitude))
        let declination = asin(sin(radObliquity) * sin(radLongitude))

        return (ra * 180 / Double.pi, declination * 180 / Double.pi)
    }

    func obliquity(_ julianDay: Double) -> Double {
        let count = 6
        // cas = Coordinates And Speeds
        let cas = UnsafeMutablePointer<Double>.allocate(capacity: count)
        cas.initialize(repeating: 0.0, count: count)
        swe_calc(julianDay, SE_ECL_NUT, 0, cas, nil)
        let obliquity = cas.pointee
        cas.deallocate()
        return obliquity
    }

}

// MARK: - ZodiacCoordinate Conformance

extension Cusp: ZodiacCoordinate {}
