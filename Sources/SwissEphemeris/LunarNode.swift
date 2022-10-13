//
//  LunarNode.swift
//  
//
//  Created by Vincent Smithers on 15.02.21.
//

import Foundation

/// Models the lunar nodes.
/// The the raw `Int32` values map to the IPL bodies.
public enum LunarNode: Int32 {
	case meanNode = 10
	case trueNode
    case meanSouthNode = 24
    case trueSouthNode = 25
}

// MARK: - CelestialBody Conformance

extension LunarNode: CelestialBody {
	public var value: Int32 {
		rawValue
	}

    var celestialObject: CelestialObject {
        return .lunarNode(self)
    }
}

