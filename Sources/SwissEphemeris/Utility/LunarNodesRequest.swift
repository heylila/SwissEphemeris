//
//  LunarNodesRequest.swift
//  
//
//  Created by Sam Krishna on 3/9/22.
//

import Foundation

/// A `BatchRequest` for a collection of `LunarNodes` `Coordinates`.
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
