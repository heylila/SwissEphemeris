//
//  AsteroidsRequest.swift
//  
//
//  Created by Sam Krishna on 3/9/22.
//

import Foundation

/// A `BatchRequest` for a collection of `Asteroid` `Coordinates`.
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
