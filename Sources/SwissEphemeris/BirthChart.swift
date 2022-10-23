//
//  BirthChart.swift
//  
//
//  Created by Sam Krishna on 10/12/22.
//

import Foundation

/// A Snapshot of the Birth Chart at a given moment in time and location.
/// Includes all planets at the time of birth.
public struct BirthChart {

    /// The "HouseCusps", which models a house system with a `Cusp` for each house, ascendent and midheaven.
    public let houseCusps: HouseCusps

    public let sun: Coordinate

    public let moon: Coordinate

    public let mercury: Coordinate

    public let venus: Coordinate

    public let mars: Coordinate

    public let jupiter: Coordinate

    public let saturn: Coordinate

    public let uranus: Coordinate

    public let neptune: Coordinate

    public let pluto: Coordinate

    public let chiron: Coordinate

    public let northNode: Coordinate

    public let southNode: Coordinate

    public let planets: [Coordinate]

    public let lunarNodes: [Coordinate]

    public init(date: Date,
                latitude: Double,
                longitude: Double,
                houseSystem: HouseSystem) {

        houseCusps = HouseCusps(date: date, latitude: latitude, longitude: longitude, houseSystem: houseSystem)

        self.sun = Coordinate(body: Planet.sun.celestialObject, date: date)
        self.moon = Coordinate(body: Planet.moon.celestialObject, date: date)
        self.mercury = Coordinate(body: Planet.mercury.celestialObject, date: date)
        self.venus = Coordinate(body: Planet.venus.celestialObject, date: date)
        self.mars = Coordinate(body: Planet.mars.celestialObject, date: date)
        self.jupiter = Coordinate(body: Planet.jupiter.celestialObject, date: date)
        self.saturn = Coordinate(body: Planet.saturn.celestialObject, date: date)
        self.uranus = Coordinate(body: Planet.uranus.celestialObject, date: date)
        self.neptune = Coordinate(body: Planet.neptune.celestialObject, date: date)
        self.pluto = Coordinate(body: Planet.pluto.celestialObject, date: date)
        self.chiron = Coordinate(body: Asteroid.chiron.celestialObject, date: date)
        self.northNode = Coordinate(body: LunarNode.meanNode.celestialObject, date: date)
        self.southNode = Coordinate(body: LunarNode.meanSouthNode.celestialObject, date: date)

        self.planets = [
            self.sun,
            self.moon,
            self.mercury,
            self.venus,
            self.mars,
            self.jupiter,
            self.saturn,
            self.uranus,
            self.neptune,
            self.pluto
        ]

        self.lunarNodes = [
            self.northNode,
            self.southNode
        ]


    }

    public var fastOrbs: Dictionary<String, Double> {
        return [
            "conjunction" : 5.0,
            "sextile" : 3.0,
            "square" : 4.0,
            "trine" : 3.0,
            "opposition" : 4.0
        ]
    }

    public var mediumOrb: Double {
        return 1.0
    }

    public var slowOrb: Double {
        return 1.0
    }

//    let fastPlanets = [
//        "sun",
//        "moon",
//        "mercury",
//        "venus",
//        "mars"
//    ]
//
//    let mediumPlanets = [
//        "jupiter",
//        "saturn"
//    ]
//
//    let slowBodies = [
//        "uranus",
//        "neptune",
//        "pluto",
//        "chiron",
//        "northnode",
//        "southnode"
//    ]
//
//
//    public let oppositions: [Aspect]?
//
//    public let trines: [Aspect]?
//
//    public let squares: [Aspect]?
//
//    public let sextiles: [Aspect]?

}
