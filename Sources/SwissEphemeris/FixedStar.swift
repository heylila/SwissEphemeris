//
//  FixedStar.swift
//  
//
//  Created by Vincent Smithers on 24.03.21.
//

import Foundation

///
public enum FixedStar: String, CaseIterable {
	///
	case galacticCenter
	///
	case aldebaran
	///
	case antares
	///
	case regulus
	///
	case sirius
	///
	case spica
	///
	case algol
	///
	case rigel
	///
	case altair
	///
	case capella
	///
	case arcturus
	///
	case procyon
	///
	case castor
	///
	case pollux
	///
	case betelgeuse

    public var formatted: String {
        switch self {
        case .galacticCenter:
            return "Galactic Center"
        case .aldebaran:
            return "Alderbaran"
        case .antares:
            return "Antares"
        case .regulus:
            return "Regulus"
        case .sirius:
            return "Sirius"
        case .spica:
            return "Spica"
        case .algol:
            return "Algol"
        case .rigel:
            return "Rigel"
        case .altair:
            return "Altair"
        case .capella:
            return "Capella"
        case .arcturus:
            return "Arcturus"
        case .procyon:
            return "Procyon"
        case .castor:
            return "Castor"
        case .pollux:
            return "Pollux"
        case .betelgeuse:
            return "Betelgeuse"
        }
    }
}

// MARK: CelestialBody Conformance

extension FixedStar: CelestialBody {
	public var value: String { rawValue }

    public var celestialObject: CelestialObject {
        return .fixedStar(self)
    }
}

