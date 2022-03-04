//
//  Sign.swift
//  
//
//  Created by Sam Krishna on 3/4/22.
//

import Foundation

/// Models the starting degree of a Zodiac sign
public struct Sign {

    /// The degree of the coordinate
    public let value: Double

    /// Creates a `Sign`.
    /// - Parameter value: The latitudinal degree to set.
    public init(value: Double) {
        self.value = (value >= 360.0) ? (value - 360.0) : value
    }
}

extension Sign: ZodiacCoordinate {}
