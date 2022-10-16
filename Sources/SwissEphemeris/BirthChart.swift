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

    public let sun: Coordinate<Planet>

    public let moon: Coordinate<Planet>

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
        self.mercury = Coordinate(body: Planet.mercury, date: date)
        self.venus = Coordinate(body: Planet.venus, date: date)
        self.mars = Coordinate(body: Planet.mars, date: date)
        self.jupiter = Coordinate(body: Planet.jupiter, date: date)
        self.saturn = Coordinate(body: Planet.saturn, date: date)
        self.uranus = Coordinate(body: Planet.uranus, date: date)
        self.neptune = Coordinate(body: Planet.neptune, date: date)
        self.pluto = Coordinate(body: Planet.pluto, date: date)
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

    public var fastBodies: [Coordinate<Planet>] {
        return [
            self.sun,
            self.moon,
            self.mercury,
            self.venus,
            self.mars
        ]
    }

    public var astroDeinstPlanetOrbs: Dictionary<Kind, Double> {
        // Astrodeinst's orbs
        return [
            .conjunction : 10.0,
            .sextile : 6.0,
            .square : 10.0,
            .trine : 10.0,
            .opposition : 10.0
        ]
    }

    public var stevensFastOrbs: Dictionary<Kind, Double> {
        return [
            .conjunction : 5.0,
            .sextile : 3.0,
            .square : 4.0,
            .trine : 3.0,
            .opposition : 4.0
        ]
    }

    public var notFastOrb: Double {
        return 0.0 // Astrodeinst orb
        // return 1.0 // Steven's orb
    }

    public var planetToPlanetAspects: [CelestialAspect<Planet, Planet>]? {
        var aspects = [CelestialAspect<Planet, Planet>]()

        for planet in self.planets {
            let filteredPlanets = self.planets.filter{ $0 != planet }

            for fp in filteredPlanets {
                for aspect in Kind.allCases {
                    let orb = astroDeinstPlanetOrbs[aspect]!
                    if let a = CelestialAspect(body1: planet, body2: fp, orb: orb) {
                        if a.kind == aspect && aspects.contains(a) == false {
                            aspects.append(a)
                        }
                    }
                }
            }
        }

        return (aspects.count > 0) ? aspects : nil
    }

    public var planetToChironAspects: [CelestialAspect<Planet, Asteroid>]? {
        var aspects = [CelestialAspect<Planet, Asteroid>]()

        for planet in self.planets {
            for aspect in Kind.allCases {
                let orb = astroDeinstPlanetOrbs[aspect]!
                if let a = CelestialAspect(body1: planet, body2: self.chiron, orb: orb) {
                    if a.kind == aspect && aspects.contains(a) == false {
                        aspects.append(a)
                    }
                }
            }
        }

        return (aspects.count > 0) ? aspects : nil
    }

    public var planetToNodeAspects: [CelestialAspect<Planet, LunarNode>]? {
        var aspects = [CelestialAspect<Planet, LunarNode>]()

        for planet in self.planets {
            for aspect in Kind.allCases {
                for node in self.lunarNodes {
                    let orb = astroDeinstPlanetOrbs[aspect]!
                    if let a = CelestialAspect(body1: planet, body2: node, orb: orb) {
                        if a.kind == aspect && aspects.contains(a) == false {
                            aspects.append(a)
                        }
                    }
                }
            }
        }

        return (aspects.count > 0) ? aspects : nil
    }


    public var chironToNodeAspects: [CelestialAspect<Asteroid, LunarNode>]? {
        var aspects = [CelestialAspect<Asteroid, LunarNode>]()

        for aspect in Kind.allCases {
            for node in self.lunarNodes {
                let orb = astroDeinstPlanetOrbs[aspect]!
                if let a = CelestialAspect(body1: self.chiron, body2: node, orb: orb) {
                    if aspects.contains(a) == false {
                        aspects.append(a)
                    }
                }
            }
        }

        return (aspects.count > 0) ? aspects : nil
    }

    public func transitingPlanets(for date: Date) -> [Coordinate<Planet>] {
        return [
            Coordinate(body: Planet.sun, date: date),
            Coordinate(body: Planet.moon, date: date),
            Coordinate(body: Planet.mercury, date: date),
            Coordinate(body: Planet.venus, date: date),
            Coordinate(body: Planet.mars, date: date),
            Coordinate(body: Planet.jupiter, date: date),
            Coordinate(body: Planet.saturn, date: date),
            Coordinate(body: Planet.uranus, date: date),
            Coordinate(body: Planet.neptune, date: date),
            Coordinate(body: Planet.pluto, date: date),
        ]
    }

    public func transitingChiron(for date: Date) -> Coordinate<Asteroid> {
        return Coordinate(body: Asteroid.chiron, date: date)
    }

    public func transitingNodes(for date: Date) -> [Coordinate<LunarNode>] {
        return [
            Coordinate(body: LunarNode.meanNode, date: date),
            Coordinate(body: LunarNode.meanSouthNode, date: date)
        ]
    }
}
