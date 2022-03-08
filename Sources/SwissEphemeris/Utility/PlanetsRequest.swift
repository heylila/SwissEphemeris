//
//  PlanetsRequest.swift
//  
//
//  Created by Vincent on 6/29/21.
//

import Foundation

/// A `BatchRequest` for a collection of `Planet` `Coordinates`.
final public class PlanetsRequest: BatchRequest {
    
    /// The `Planet` to request.
    private let body: Planet
    public typealias EphemerisItem = Coordinate<Planet>
    public let datesThreshold = 478
    
    /// Creates an instance of `PlanetsRequest`.
    /// - Parameter body: The planet to request.
    public init(body: Planet) {
        self.body = body
    }
	
	public func fetch(start: Date, end: Date, interval: TimeInterval = 60.0) -> [EphemerisItem] {
        stride(from: start, to: end, by: interval).map {
            EphemerisItem(body: body, date: $0)
        }
	}
}

final public class AsteroidsRequest: BatchRequest {
    /// The `Asteroids` to request.
    private let body: Asteroid
    public typealias EphemerisItem = Coordinate<Asteroid>
    public let datesThreshold = 478

    /// Creates an instance of `AsteroidsRequest`.
    /// - Parameter body: The asteroid to request.
    public init(body: Asteroid) {
        self.body = body
    }

    public func fetch(start: Date, end: Date, interval: TimeInterval = 60.0) -> [EphemerisItem] {
        stride(from: start, to: end, by: interval).map {
            EphemerisItem(body: body, date: $0)
        }
    }

}

final public class LunarNodesRequest: BatchRequest {
    /// The `LunarNode` to request.
    private let body: LunarNode
    public typealias EphemerisItem = Coordinate<LunarNode>
    public let datesThreshold = 478

    /// Creates an instance of `LunarNodesRequest`.
    /// - Parameter body: The lunar node to request.
    public init(body: LunarNode) {
        self.body = body
    }

    public func fetch(start: Date, end: Date, interval: TimeInterval = 60.0) -> [EphemerisItem] {
        stride(from: start, to: end, by: interval).map {
            EphemerisItem(body: body, date: $0)
        }
    }
}
