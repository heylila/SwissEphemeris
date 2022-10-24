//
//  CelestialObject.swift
//  
//
//  Created by Sam Krishna on 10/12/22.
//

import Foundation

public enum CelestialObject: Codable, Equatable, Hashable {
    case asteroid(Asteroid)
    case lunarNode(LunarNode)
    case planet(Planet)
    case fixedStar(FixedStar)
}

extension CelestialObject {
    var asteroid: Asteroid? {
        switch self {
        case let .asteroid(asteroid):
            return asteroid
        default:
            return nil
        }
    }

    var planet: Planet? {
        switch self {
        case let .planet(planet):
            return planet
        default:
            return nil
        }
    }

    var lunarNode: LunarNode? {
        switch self {
        case let .lunarNode(lunarNode):
            return lunarNode
        default:
            return nil
        }
    }

    var fixedStar: FixedStar? {
        switch self {
        case let .fixedStar(fixedStar):
            return fixedStar
        default:
            return nil
        }
    }
}
