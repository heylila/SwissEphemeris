//
//  Cusp.swift
//  
//
//  Created by Vincent Smithers on 08.02.21.
//

import Foundation

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
}

// MARK: - ZodiacCoordinate Conformance

extension Cusp: ZodiacCoordinate {}
