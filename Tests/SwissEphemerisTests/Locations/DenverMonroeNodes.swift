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

    static var planets: [String : Coordinate<Planet> ] {
        return [
            Planet.sun.formatted : Coordinate(body: .sun, date: birthDate),
            Planet.moon.formatted : Coordinate(body: .moon, date: birthDate),
            Planet.mercury.formatted : Coordinate(body: .mercury, date: birthDate),
            Planet.venus.formatted : Coordinate(body: .venus, date: birthDate),
            Planet.mars.formatted : Coordinate(body: .mars, date: birthDate),
            Planet.jupiter.formatted : Coordinate(body: .jupiter, date: birthDate),
            Planet.saturn.formatted : Coordinate(body: .saturn, date: birthDate),
            Planet.uranus.formatted : Coordinate(body: .uranus, date: birthDate),
            Planet.neptune.formatted : Coordinate(body: .neptune, date: birthDate),
            Planet.pluto.formatted : Coordinate(body: .pluto, date: birthDate)
        ]
    }

    static var nodes: [String : Coordinate<LunarNode> ] {
        return [
            "North Node" : Coordinate(body: LunarNode.meanNode, date: birthDate),
            "South Node" : Coordinate(body: LunarNode.meanSouthNode, date: birthDate)
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
