//
//  RoundingPrecision.swift
//  
//
//  Created by Sam Krishna on 8/10/22.
//

import Foundation

public enum RoundingPrecision {
    case ones
    case tenths
    case hundredths
    case thousandths
    case tenThousandths
    case hundredThousandths
}

public func preciseRound(_ value: Double, precision: RoundingPrecision = .ones) -> Double {
    switch precision {
    case .ones:
        return round(value)
    case .tenths:
        return round(value * 10) / 10.0
    case .hundredths:
        return round(value * 100) / 100.0
    case .thousandths:
        return round(value * 1000) / 1000.0
    case .tenThousandths:
        return round(value * 10000) / 10000.0
    case .hundredThousandths:
        return round(value * 100000) / 100000.0
    }
}
