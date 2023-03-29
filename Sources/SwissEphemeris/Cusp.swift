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

	/// Creates a `Cusp`.
	/// - Parameter value: The latitudinal degree to set.
    public init(value: Double, name: String, number: Int) {
		self.value = value
        self.name = name
        self.number = number
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

    func obliquity(julianDay: Double) -> Double {
        var eps = UnsafeMutablePointer<Double>.allocate(capacity: 1)
        swe_calc(julianDay, SE_ECL_NUT, 0, eps, nil)
        let obliquity = eps.pointee
        eps.deallocate()
        return obliquity
    }

}

// MARK: - ZodiacCoordinate Conformance

extension Cusp: ZodiacCoordinate {}
