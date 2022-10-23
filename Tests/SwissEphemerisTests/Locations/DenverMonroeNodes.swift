//
//  DenverMonroeNodes.swift
//  
//
//  Created by Sam Krishna on 8/29/22.
//

import XCTest
@testable import SwissEphemeris

class DenverMonroeNodes: XCTestCase {

    override func setUpWithError() throws {
        JPLFileManager.setEphemerisPath()
    }

    static var birthDate: Date {
        let dob = "1985-07-03 12:57:00 -0500"
        let dobDate = Date(fromString: dob, format: .cocoaDateTime)!
        return dobDate
    }

    static var chart: HouseCusps {
        let lat = 32.5093109
        let long = -92.1193012
        return HouseCusps(date: birthDate, latitude: lat, longitude: long, houseSystem: .placidus)
    }

    static var planets: [String : Coordinate ] {
        return [
            Planet.sun.formatted : Coordinate(body: Planet.sun.celestialObject, date: birthDate),
            Planet.moon.formatted : Coordinate(body: Planet.moon.celestialObject, date: birthDate),
            Planet.mercury.formatted : Coordinate(body: Planet.mercury.celestialObject, date: birthDate),
            Planet.venus.formatted : Coordinate(body: Planet.venus.celestialObject, date: birthDate),
            Planet.mars.formatted : Coordinate(body: Planet.mars.celestialObject, date: birthDate),
            Planet.jupiter.formatted : Coordinate(body: Planet.jupiter.celestialObject, date: birthDate),
            Planet.saturn.formatted : Coordinate(body: Planet.saturn.celestialObject, date: birthDate),
            Planet.uranus.formatted : Coordinate(body: Planet.uranus.celestialObject, date: birthDate),
            Planet.neptune.formatted : Coordinate(body: Planet.neptune.celestialObject, date: birthDate),
            Planet.pluto.formatted : Coordinate(body: Planet.pluto.celestialObject, date: birthDate)
        ]
    }

    static var nodes: [String : Coordinate ] {
        return [
            "North Node" : Coordinate(body: LunarNode.meanNode.celestialObject, date: birthDate),
            "South Node" : Coordinate(body: LunarNode.meanSouthNode.celestialObject, date: birthDate)
        ]
    }

    func testExample() throws {
        let chart = DenverMonroeNodes.chart
        let nodes = DenverMonroeNodes.nodes
        let nnode = nodes["North Node"]
        let snode = nodes["South Node"]
        let nnodeCusp = chart.cuspForLongitude(nnode!.longitude)
        let snodeCusp = chart.cuspForLongitude(snode!.longitude)

        XCTAssert(nnodeCusp!.name == "eighth")
        XCTAssert(snodeCusp!.name == "second")
        XCTAssert(nnodeCusp!.number == 8)
        XCTAssert(snodeCusp!.number == 2)
    }

}
