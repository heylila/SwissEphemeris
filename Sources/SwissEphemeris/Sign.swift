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
    public let houseNumber: Int

    public var sign: Zodiac { Zodiac(rawValue: houseNumber)! }

    var degree: Double { value }

    var minute: Double { value.truncatingRemainder(dividingBy: 1) * 60 }

    var second: Double { minute.truncatingRemainder(dividingBy: 1) * 60 }

    /// Creates a `Sign`.
    /// - Parameter value: The latitudinal degree to set, based on the ascendant being 0 degrees.
    public init(value: Double, houseNumber: Int) {
        let preRoundedValue = (value >= 360.0) ? (value - 360.0) : value
        self.value = round(preRoundedValue * 1000) / 1000.0
        assert(houseNumber >= 0 && houseNumber < 12)
        self.houseNumber = houseNumber
    }

    public var range: Range<Double> {
        return degree..<(degree + 30.0)
    }

    var formatted: String {
        "\(Int(degree)) Degrees (from Asc) " +
        "\(sign.formatted) " +
        "\(Int(minute))' " +
        "\(Int(second))''"
    }
}
