//
//  CelestialBody.swift
//  
//
//  Created by Vincent Smithers on 11.02.21.
//

import Foundation

/// Models a planet, moon, asteroid, star or celestial body both real or imaginary.
public protocol CelestialBody: CaseIterable, Codable, Equatable {
	associatedtype DateType
	/// The IPL body number.
	var value: DateType { get }
}
