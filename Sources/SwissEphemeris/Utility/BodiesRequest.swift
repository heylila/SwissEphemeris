//
//  BodiesRequest.swift
//  
//
//  Created by Sam Krishna on 03.13.22
//

import Foundation

public enum TimeSlice: Double, CaseIterable {
    case minute
    case hour
    case day
    case month

    public var slice: Double {
        switch self {
        case .minute:
            return Double(60)
        case .hour:
            return Double(60 * 60)
        case .day:
            return Double(24 * 60 * 60)
        case .month:
            return Double(28 * 24 * 60 * 60)
        }
    }
}

/// A generic `BatchRequest` for a collection of `<BodyType>` `Coordinates`.
final public class BodiesRequest<BodyType>: BatchRequest where BodyType: CelestialBody {

    /// The `BodyType` to request (usually `Planet` or `LunarNode` or `Asteroid`)
    private let body: BodyType
    public typealias EphemerisItem = Coordinate<BodyType>
    public let datesThreshold = 478

    /// Creates an instance of `BodiesRequest of type <BodyType>`.
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
