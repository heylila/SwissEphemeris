//
//  BodiesRequest.swift
//  
//
//  Created by Sam Krishna on 3/13/22.
//

import Foundation

/// A generic `BatchRequest` for a collection of `<BodyType>` `Coordinates`.
final public class BodiesRequest<BodyType>: BatchRequest where BodyType: CelestialBody {

    /// The `BodyType` to request (usually `Planet` or `LunarNode` or `Asteroid`)
    private let body: BodyType
    public typealias EphemerisItem = Coordinate<BodyType>
    public let datesThreshold = 478

    /// Creates an instance of `<BodyType>Request`.
    /// - Parameter body: The planet to request.
    public init(body: BodyType) {
        self.body = body
    }

    public func fetch(start: Date, end: Date, interval: TimeInterval = 60.0) -> [EphemerisItem] {
        stride(from: start, to: end, by: interval).map {
            EphemerisItem(body: body, date: $0)
        }
    }
}
