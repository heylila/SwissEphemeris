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

    public let allBodies: [Coordinate]

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

        self.allBodies = [
            self.sun,
            self.moon,
            self.mercury,
            self.venus,
            self.mars,
            self.jupiter,
            self.saturn,
            self.uranus,
            self.neptune,
            self.pluto,
            self.northNode,
            self.southNode,
            self.chiron
        ]
    }

    var fastBodies: [Coordinate] {
        return [
            self.sun,
            self.moon,
            self.mercury,
            self.venus,
            self.mars
        ]
    }

    var astroDeinstPlanetOrbs: Dictionary<Kind, Double> {
        // Astrodeinst's orbs
        return [
            .conjunction : 10.0,
            .sextile : 6.0,
            .square : 10.0,
            .trine : 10.0,
            .opposition : 10.0
        ]
    }

    var stevensFastOrbs: Dictionary<Kind, Double> {
        return [
            .conjunction : 5.0,
            .sextile : 3.0,
            .square : 4.0,
            .trine : 3.0,
            .opposition : 4.0
        ]
    }

    var notFastOrb: Double {
        return 0.0 // Astrodeinst orb
        // return 1.0 // Steven's orb
    }

    public var planetToPlanetAspects: [CelestialAspect]? {
        var aspects = [CelestialAspect]()

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

    public var planetToChironAspects: [CelestialAspect]? {
        var aspects = [CelestialAspect]()

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

    public var planetToNodeAspects: [CelestialAspect]? {
        var aspects = [CelestialAspect]()

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


    public var chironToNodeAspects: [CelestialAspect]? {
        var aspects = [CelestialAspect]()

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

    public var allAspects: [CelestialAspect]? {
        var aspects = [CelestialAspect]()

        for aBody in self.allBodies {
            let filteredBodies = self.allBodies.filter{ $0 != aBody }

            for fp in filteredBodies {
                for aspect in Kind.allCases {
                    let orb = astroDeinstPlanetOrbs[aspect]!
                    if let a = CelestialAspect(body1: aBody, body2: fp, orb: orb) {
                        if a.kind == aspect && aspects.contains(a) == false {
                            aspects.append(a)
                        }
                    }
                }
            }
        }

        return (aspects.count > 0) ? aspects : nil
    }

    public func snapshotOfPlanets(for date: Date) -> [Coordinate] {
        return [
            Coordinate(body: Planet.sun.celestialObject, date: date),
            Coordinate(body: Planet.moon.celestialObject, date: date),
            Coordinate(body: Planet.mercury.celestialObject, date: date),
            Coordinate(body: Planet.venus.celestialObject, date: date),
            Coordinate(body: Planet.mars.celestialObject, date: date),
            Coordinate(body: Planet.jupiter.celestialObject, date: date),
            Coordinate(body: Planet.saturn.celestialObject, date: date),
            Coordinate(body: Planet.uranus.celestialObject, date: date),
            Coordinate(body: Planet.neptune.celestialObject, date: date),
            Coordinate(body: Planet.pluto.celestialObject, date: date),
        ]
    }

    public func snapshotOfChiron(for date: Date) -> Coordinate {
        return Coordinate(body: Asteroid.chiron.celestialObject, date: date)
    }

    public func snapshotOfNodes(for date: Date) -> [Coordinate] {
        return [
            Coordinate(body: LunarNode.meanNode.celestialObject, date: date),
            Coordinate(body: LunarNode.meanSouthNode.celestialObject, date: date)
        ]
    }

    public func transitType(for body: CelestialObject, with natalBody: Coordinate, on date: Date, orb: Double = 2.0) -> Kind? {
        let bodyCoordinate = Coordinate(body: body, date: date)
        if let a = CelestialAspect(body1: bodyCoordinate, body2: natalBody, orb: orb) {
            return a.kind
        }

        return nil
    }

    public func transitType(for body: CelestialObject, with cusp: Cusp, on date: Date, orb: Double = 2.0) -> Kind? {
        let bodyCoordinate = Coordinate(body: body, date: date)
        let kind: Kind
        if let a = Aspect(a: bodyCoordinate.longitude, b: cusp.value, orb: orb) {
            switch a {
            case .conjunction(_):
                kind = .conjunction
            case .sextile(_):
                kind = .sextile
            case .square(_):
                kind = .square
            case .trine(_):
                kind = .trine
            case .opposition(_):
                kind = .opposition
            }

            return kind
        }

        return nil
    }

    public func transitingCoordinates(for transitingBody: Coordinate, with natalBody: Coordinate, on date: Date) -> (first: Coordinate, last: Coordinate)? {

        // So, IF we have a transiting aspect on a particular date, what we want to find is:
        // The absolute BEGINNING minute of the transiting aspect
        // The absolute ENDING minute of the transiting asect
        // Think of this as a inclusive interval: [ <starting minute>, ... , <ending minute> ]

        // Best way to do this is in days, and using inspiration from
        // "sliceTimeForEgress / sliceTimeForIngress"

        // Will return nil IF there's no aspect on the provided date

        let orb = 2.0
        guard let a = CelestialAspect(body1: transitingBody, body2: natalBody, orb: orb) else {
            return nil
        }

        let TBody = transitingBody
        var yesterday: CelestialAspect? = a
        var tomorrow: CelestialAspect? = a
        var dayBefore = date
        var dayAfter = date

        while yesterday != nil {
            dayBefore = dayBefore.offset(.day, value: -1)!
            let yesterdayTBody = Coordinate(body: TBody.body, date: dayBefore)
            yesterday = CelestialAspect(body1: yesterdayTBody, body2: natalBody, orb: orb)
        }

        while tomorrow != nil {
            dayAfter = dayAfter.offset(.day, value: 1)!
            let tomorrowTBody = Coordinate(body: TBody.body, date: dayAfter)
            tomorrow = CelestialAspect(body1: tomorrowTBody, body2: natalBody, orb: orb)
        }

        let beforeFirstDay = dayBefore
        let firstDay = dayBefore.offset(.day, value: 1)!
        let afterLastDay = dayAfter
        let lastDay = dayAfter.offset(.day, value: -1)!

        var positions = BodiesRequest(body: TBody.body).fetch(start: beforeFirstDay, end: firstDay, interval: TimeSlice.minute.slice)
        let starting = positions.first { now in
            let a = Aspect(bodyA: now, bodyB: natalBody, orb: orb)
            return a != nil
        }

        positions = BodiesRequest(body: TBody.body).fetch(start: lastDay, end: afterLastDay, interval: TimeSlice.minute.slice)
        let ending = positions.last { now in
            let a = Aspect(bodyA: now, bodyB: natalBody, orb: orb)
            return a != nil
        }

        return (starting, ending) as? (first: Coordinate, last: Coordinate)
    }

    public func transitingCoordinates(for transitingBody: Coordinate, with cusp: Cusp, on date: Date) -> (first: Coordinate, last: Coordinate)? {
        let orb = 2.0
        let TBody = transitingBody

        guard let a = Aspect(a: TBody.longitude, b: cusp.value, orb: orb) else {
            return nil
        }

        var yesterday: Aspect? = a
        var tomorrow: Aspect? = a
        var dayBefore = date
        var dayAfter = date

        while yesterday != nil {
            dayBefore = dayBefore.offset(.day, value: -1)!
            let yesterdayTBody = Coordinate(body: TBody.body, date: dayBefore)
            yesterday = Aspect(a: yesterdayTBody.longitude, b: cusp.value, orb: orb)
        }

        while tomorrow != nil {
            dayAfter = dayAfter.offset(.day, value: 1)!
            let tomorrowTBody = Coordinate(body: TBody.body, date: dayAfter)
            tomorrow = Aspect(a: tomorrowTBody.longitude, b: cusp.value, orb: orb)
        }

        let beforeFirstDay = dayBefore
        let firstDay = dayBefore.offset(.day, value: 1)!
        let afterLastDay = dayAfter
        let lastDay = dayAfter.offset(.day, value: -1)!

        var positions = BodiesRequest(body: TBody.body).fetch(start: beforeFirstDay, end: firstDay, interval: TimeSlice.minute.slice)
        let starting = positions.first { now in
            let a = Aspect(a: now.longitude, b: cusp.value, orb: orb)
            return a != nil
        }

        positions = BodiesRequest(body: TBody.body).fetch(start: lastDay, end: afterLastDay, interval: TimeSlice.minute.slice)
        let ending = positions.last { now in
            let a = Aspect(a: now.longitude, b: cusp.value, orb: orb)
            return a != nil
        }

        return (starting, ending) as? (first: Coordinate, last: Coordinate)
    }
}
