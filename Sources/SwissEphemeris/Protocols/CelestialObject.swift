//
//  CelestialObject.swift
//  
//
//  Created by Sam Krishna on 10/12/22.
//

import Foundation

public enum CelestialObject {
    case asteroid(Asteroid)
    case lunarNode(LunarNode)
    case planet(Planet)
    case fixedStar(FixedStar)
}
