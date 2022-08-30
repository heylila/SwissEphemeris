//
//  SynodicDate.swift
//  
//
//  Created by Sam Krishna on 8/29/22.
//

import Foundation

public extension Date {

//    public func time(of phase: MoonPhase, forward: Bool = true, mean: Bool = true) -> JulianDay {
//        var k = floor(KPCAAMoonPhases_K(self.julianDay.date.fractionalYear))
//        switch phase {
//        case .newMoon:
//            k = k + 0.0
//        case .waxingCrescent:
//            k = k + 0.125
//        case .firstQuarter:
//            k = k + 0.25
//        case .waxingGibbous:
//            k = k + 0.375
//        case .fullMoon:
//            k = k + 0.50
//        case .waningGibbous:
//            k = k + 0.675
//        case .lastQuarter:
//            k = k + 0.75
//        case .waningCrescent:
//            k = k + 0.875
//        }

    // From https://www.britannica.com/science/synodic-month
    func incrementBySynodicMonth() -> Date {
        let plusMonth = self.offset(.day, value: 29)!.offset(.hour, value: 12)!.offset(.minute, value: 44)!.offset(.second, value: 3)!
        return plusMonth
    }

    
}
