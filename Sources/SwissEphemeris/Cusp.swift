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

    /// This is the declination angle of the Cusp. It requires its
    public var declination: Double {
        let julianDay = self.date.julianDate()
        let obliquityOfEcliptic = obliquity(julianDay)
        let _declination = eclipticToEquatorial(obliquity: obliquityOfEcliptic)
        return _declination
    }

    func eclipticToEquatorial(obliquity: Double) -> Double {
        let radLongitude = self.value * Double.pi / 180
        let radObliquity = obliquity * Double.pi / 180
        let declination = asin(sin(radObliquity) * sin(radLongitude))
        return (declination * 180 / Double.pi)
    }

    func obliquity(_ julianDay: Double) -> Double {
        // We only know the count by reading the documentation for swe_calc() or the source code
        // The O.G. API documentation is here:
        // https://www.astro.com/swisseph/swephprg.htm#_Toc112948958
        //
        // It specifically says "xx = array of 6 doubles for longitude, latitude, distance, speed in long., speed in lat., and speed in dist.

        let casCount = 6
        // cas = Coordinates And Speeds
        let cas = UnsafeMutablePointer<Double>.allocate(capacity: casCount)
        cas.initialize(repeating: 0.0, count: casCount)
        swe_calc(julianDay, SE_ECL_NUT, 0, cas, nil)
        let obliquity = cas.pointee
        cas.deallocate()
        return obliquity
    }

}

// MARK: - ZodiacCoordinate Conformance

extension Cusp: ZodiacCoordinate {}
