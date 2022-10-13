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

    public let sun: Coordinate<CelestialObject>

    public let moon: Coordinate<CelestialObject>

    public let mercury: Coordinate<Planet>

    public let venus: Coordinate<Planet>

    public let mars: Coordinate<Planet>

    public let jupiter: Coordinate<Planet>

    public let saturn: Coordinate<Planet>

    public let uranus: Coordinate<Planet>

    public let neptune: Coordinate<Planet>

    public let pluto: Coordinate<Planet>

    public let chiron: Coordinate<Asteroid>

    public let northNode: Coordinate<LunarNode>

    public let southNode: Coordinate<LunarNode>

    public let planets: [Coordinate<Planet>]

    public let lunarNodes: [Coordinate<LunarNode>]

    public init(date: Date,
                latitude: Double,
                longitude: Double,
                houseSystem: HouseSystem) {

        houseCusps = HouseCusps(date: date, latitude: latitude, longitude: longitude, houseSystem: houseSystem)

        self.sun = Coordinate(body: Planet.sun, date: date)
        self.moon = Coordinate(body: Planet.moon, date: date)
        self.mercury = Coordinate(body: Planet.moon, date: date)
        self.venus = Coordinate(body: Planet.moon, date: date)
        self.mars = Coordinate(body: Planet.moon, date: date)
        self.jupiter = Coordinate(body: Planet.moon, date: date)
        self.saturn = Coordinate(body: Planet.moon, date: date)
        self.uranus = Coordinate(body: Planet.moon, date: date)
        self.neptune = Coordinate(body: Planet.moon, date: date)
        self.pluto = Coordinate(body: Planet.moon, date: date)
        self.chiron = Coordinate(body: Asteroid.chiron, date: date)
        self.northNode = Coordinate(body: LunarNode.meanNode, date: date)
        self.southNode = Coordinate(body: LunarNode.meanSouthNode, date: date)

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

    public var conjunctions: [CelestialAspect<CelestialObject, CelestialObject>]? {
        var conjs = [CelestialAspect<CelestialObject, CelestialObject>]()

        for planet in self.planets {
            let filteredPlanets = self.planets.filter{ $0 != planet }

            for fp in filteredPlanets {

            }
        }

        return conjs
    }

//
//    public let oppositions: [Aspect]?
//
//    public let trines: [Aspect]?
//
//    public let squares: [Aspect]?
//
//    public let sextiles: [Aspect]?

}
