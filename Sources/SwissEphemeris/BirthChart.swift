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

        sun = Coordinate(body: Planet.sun.celestialObject, date: date)
        moon = Coordinate(body: Planet.moon.celestialObject, date: date)
        mercury = Coordinate(body: Planet.mercury.celestialObject, date: date)
        venus = Coordinate(body: Planet.venus.celestialObject, date: date)
        mars = Coordinate(body: Planet.mars.celestialObject, date: date)
        jupiter = Coordinate(body: Planet.jupiter.celestialObject, date: date)
        saturn = Coordinate(body: Planet.saturn.celestialObject, date: date)
        uranus = Coordinate(body: Planet.uranus.celestialObject, date: date)
        neptune = Coordinate(body: Planet.neptune.celestialObject, date: date)
        pluto = Coordinate(body: Planet.pluto.celestialObject, date: date)
        chiron = Coordinate(body: Asteroid.chiron.celestialObject, date: date)
        northNode = Coordinate(body: LunarNode.meanNode.celestialObject, date: date)
        southNode = Coordinate(body: LunarNode.meanSouthNode.celestialObject, date: date)

        planets = [
            sun,
            moon,
            mercury,
            venus,
            mars,
            jupiter,
            saturn,
            uranus,
            neptune,
            pluto
        ]

        lunarNodes = [
            northNode,
            southNode
        ]

        allBodies = [
            sun,
            moon,
            mercury,
            venus,
            mars,
            jupiter,
            saturn,
            uranus,
            neptune,
            pluto,
            northNode,
            southNode,
            chiron
        ]
    }

    public static var allBodyCases: [CelestialObject] {
        return [
            Planet.sun.celestialObject,
            Planet.moon.celestialObject,
            Planet.mercury.celestialObject,
            Planet.venus.celestialObject,
            Planet.mars.celestialObject,
            Planet.jupiter.celestialObject,
            Planet.saturn.celestialObject,
            Planet.uranus.celestialObject,
            Planet.neptune.celestialObject,
            Planet.pluto.celestialObject,
            LunarNode.meanNode.celestialObject,
            LunarNode.meanSouthNode.celestialObject,
            Asteroid.chiron.celestialObject
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

    public func snapshotOfTransitingBodies(for date: Date) -> [Coordinate] {
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
            Coordinate(body: LunarNode.meanNode.celestialObject, date: date),
            Coordinate(body: LunarNode.meanSouthNode.celestialObject, date: date),
            Coordinate(body: Asteroid.chiron.celestialObject, date: date)
        ]
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

    public func aspects(for natalBody: Coordinate, on date: Date, with orb: Double = 2.0) -> [CelestialAspect]? {
        let bodies = snapshotOfTransitingBodies(for: date)
        var aspects = [CelestialAspect]()

        for Tbody in bodies {
            if let ca = CelestialAspect(body1: Tbody, body2: natalBody, orb: orb) {
                aspects.append(ca)
            }
        }

        return aspects.count > 0 ? aspects : nil
    }

    public func transitType(for Tbody: CelestialObject, with natalBody: Coordinate, on date: Date, orb: Double = 2.0) -> Kind? {
        let bodyCoordinate = Coordinate(body: Tbody, date: date)
        if let a = CelestialAspect(body1: bodyCoordinate, body2: natalBody, orb: orb) {
            return a.kind
        }

        return nil
    }

    public func transitType(for Tbody: CelestialObject, with cusp: Cusp, on date: Date, orb: Double = 2.0) -> Kind? {
        let bodyCoordinate = Coordinate(body: Tbody, date: date)
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

    public func transitingCoordinates(for transitingBody: CelestialObject, with natalBody: Coordinate, on date: Date, orb: Double = 2.0) -> (first: Coordinate, last: Coordinate)? {
        precondition(transitingBody != .all, "All is not allowed")
        precondition(transitingBody != .noBody, "No Body is not allowed")

        let TBody = Coordinate(body: transitingBody, date: date)
        guard let a = CelestialAspect(body1: TBody, body2: natalBody, orb: orb) else {
            return nil
        }

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

    public func transitingCoordinates(for transitingBody: CelestialObject, with cusp: Cusp, on date: Date, orb: Double = 2.0) -> (first: Coordinate, last: Coordinate)? {
        precondition(transitingBody != .all, "All is not allowed")
        precondition(transitingBody != .noBody, "No Body is not allowed")
        let TBody = Coordinate(body: transitingBody, date: date)
        guard let a = Aspect(body: TBody, cusp: cusp, orb: orb) else {
            return nil
        }

        var yesterday: Aspect? = a
        var tomorrow: Aspect? = a
        var dayBefore = date
        var dayAfter = date

        while yesterday != nil {
            dayBefore = dayBefore.offset(.day, value: -1)!
            let yesterdayTBody = Coordinate(body: TBody.body, date: dayBefore)
            yesterday = Aspect(body: yesterdayTBody, cusp: cusp, orb: orb)
        }

        while tomorrow != nil {
            dayAfter = dayAfter.offset(.day, value: 1)!
            let tomorrowTBody = Coordinate(body: TBody.body, date: dayAfter)
            tomorrow = Aspect(body: tomorrowTBody, cusp: cusp, orb: orb)
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

    public func findNextAspect(for body: CelestialObject, with natal: Coordinate, on date: Date, with orb: Double = 2.0) -> (date: Date, aspect: CelestialAspect) {

        let TBody = Coordinate(body: body, date: date)
        if let a = CelestialAspect(body1: TBody, body2: natal, orb: orb) {
            return (date, a)
        }

        var aspect: CelestialAspect?
        var tomorrow = date

        while aspect == nil {
            tomorrow = tomorrow.offset(.day, value: 1)!
            let tomorrowTBody = Coordinate(body: TBody.body, date: tomorrow)
            aspect = CelestialAspect(body1: tomorrowTBody, body2: natal, orb: orb)
        }

        return (tomorrow, aspect!)
    }

}

/*
extension BirthChart {
    public static var aspectTransits: [CelestialObject : (dateType: Date.DateComponentType, amount: Int)] {
        let d: [ CelestialObject : (dateType: Date.DateComponentType, amount: Int) ] = [
            Planet.sun.celestialObject : (.day, 40),
            Planet.mercury.celestialObject : (.day, 70),
            Planet.venus.celestialObject : (.day, 75),
            Planet.mars.celestialObject : (.month, 8),
            Planet.jupiter.celestialObject : (.month, 24),
            Planet.saturn.celestialObject : (.month, Int(2.8 * 12)),
            Planet.uranus.celestialObject : (.month, Int(8 * 12)),
            Planet.neptune.celestialObject : (.month, Int(15 * 12)),
            Planet.pluto.celestialObject : (.month, Int(32 * 12)),
            LunarNode.meanNode.celestialObject : (.month, Int(1.55 * 12)),
            LunarNode.meanSouthNode.celestialObject : (.month, Int(1.55 * 12)),
            Asteroid.chiron.celestialObject : (.month, Int(8.25 * 12))
        ]

        return d
    }

    public func findPeakCoordinate(for transitingBody: CelestialObject, with natalBody: Coordinate, on date: Date, orb: Double = 2.0) -> Coordinate? {
        let TBody = Coordinate(body: transitingBody, date: date)
        guard let a = CelestialAspect(body1: TBody, body2: natalBody, orb: orb) else {
            return nil
        }

        if a.angle == 0.0 {
            return TBody
        }

        let kind = a.kind

        func getBestPosition(for start: Date, end: Date, slice: TimeInterval) -> Coordinate? {
            let positions = BodiesRequest(body: transitingBody).fetch(start: start, end: end, interval: slice)
            let range = -1.0...1.0
            let outcome = positions.min { lhs, rhs in
                guard let aspect = CelestialAspect(body1: lhs, body2: natalBody, orb: orb) else {
                    return false
                }

                return kind == aspect.kind && range.contains(abs(aspect.angle))
            }

            return outcome
        }

        // OK so now the trick will be to get the "best minute" of a position
        // that has as close to a ZERO degree for the remainder for a particular aspect
        guard let tuple = BirthChart.aspectTransits[transitingBody] else { return nil }
        var yesterdayStart = date.offset(tuple.dateType, value: (-1 * tuple.amount))!
        var tomorrowEnd = date.offset(tuple.dateType, value: tuple.amount)!
        let slices = TimeSlice.typicalSlices

        for i in stride(from: 1, to: TimeSlice.typicalSlices.endIndex, by: 1) {
            let window = slices[i]
            let best = getBestPosition(for: yesterdayStart, end: tomorrowEnd, slice: window.slice)

        }

        return nil
    }
}
*/
