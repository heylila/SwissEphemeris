//
//  Aspect.swift
//  
//
//  29.08.20.
//

import Foundation

public struct CelestialAspect: Codable {
    public enum Kind: Codable {
        /// A 0° alignment.
        case conjunction
        /// A 60° alignment.
        case sextile
        /// A 90° alignment.
        case square
        /// A 120° alignment.
        case trine
        /// An 180° alignment.
        case opposition
    }

    public let kind: Kind
    public let body1: CelestialObject
    public let body2: CelestialObject
    public let angle: Double

    public init?(body1: CelestialObject, body2: CelestialObject, orb: Double) {
        if let a = Aspect(a: body1.longitude, b: body2.longitude, orb: orb) {
            self.body1 = body1
            self.body2 = body2

            switch a {
            case .conjunction(_):
                self.angle = 0.0 + a.remainder
                self.kind = .conjunction
            case .sextile(_):
                self.angle = 60.0 + a.remainder
                self.kind = .sextile
            case .square(_):
                self.angle = 90.0 + a.remainder
                self.kind = .square
            case .trine(_):
                self.angle = 120.0 + a.remainder
                self.kind = .trine
            case .opposition(_):
                self.angle = 180.0 + a.remainder
                self.kind = .opposition
            }

            return
        }

        return nil
    }
}

/// Models a geometric aspect between two bodies.
public enum Aspect: Equatable, Hashable, Codable {

    // Possible name of struct:
    // InterestingInterBodyAngle
    //      - Angle
    //      - Planet 1
    //      - Planet 2

	/// A 0° alignment.
    case conjunction(Double)
	/// A 60° alignment.
    case sextile(Double)
	/// A 90° alignment.
    case square(Double)
	/// A 120° alignment.
    case trine(Double)
	/// An 180° alignment.
    case opposition(Double)

	/// Creates an optional `Aspect`. If there is no aspect within the orb, then this initializer will return `nil`.
	/// - Parameters:
	///   - pair: The two bodies to compare.
	///   - date: The date of the alignment.
	///   - orb: The number of degrees allowed for the aspect to differ from exactness.
    public init?<T, U>(pair: Pair<T, U>, date: Date, orb: Double = 10.0) {
		let degreeA = Coordinate(body: pair.a, date: date)
		let degreeB = Coordinate(body: pair.b, date: date)
		self.init(a: degreeA.value, b: degreeB.value, orb: orb)
	}
	
	/// Creates an optional `Aspect` between two degrees. If there is no aspect within the orb, then this initializer will return `nil`.
	/// - Parameters:
	///   - a: The first degree in the pair.
	///   - b: The second degree in the pair.
	///   - orb: The number of degrees allowed for the aspect to differ from exactness.
	public init?(a: Double, b: Double, orb: Double) {
		let aspectValue = abs(b - a) >= 180 ?
			abs(abs(b - a) - 360) : abs(b - a)
		switch aspectValue {
		case (0 - orb)...(0 + orb):
			self = .conjunction(round(aspectValue * 100) / 100)
		case (60 - orb)...(60 + orb):
			self = .sextile(round((aspectValue - 60) * 100) / 100)
		case (90 - orb)...(90 + orb):
			self = .square(round((aspectValue - 90) * 100) / 100)
		case (120 - orb)...(120 + orb):
			self = .trine(round((aspectValue - 120) * 100) / 100)
		case (180 - orb)...(180 + orb):
			self = .opposition(round((aspectValue - 180) * 100) / 100)
		default:
			return nil
		}
	}

    /// Creates an optional `Aspect` between two Coordinates. Useful for generalizng between different aspect configurations (usually between a Transiting Body and a Natal Body). If there is no aspect within the orb, then this initializer will return `nil`.
    /// - Parameters:
    ///   - bodyA: The first body of the aspect.
    ///   - bodyB: The second body of the aspect
    ///   - orb: The number of degrees allowed for the aspect to differ from exactness.
    public init?<T, U>(bodyA: Coordinate<T>, bodyB: Coordinate<U>, orb: Double = 10.0) {
        self.init(a: bodyA.longitude, b: bodyB.longitude, orb: orb)
    }

	/// The symbol commonly associated with the aspect.
    public var symbol: String? {
        switch self {
        case .conjunction:
            return "☌"
        case .sextile:
            return "﹡"
        case .square:
            return "◾️"
        case .trine:
            return "▵"
        case .opposition:
            return "☍"
        }
    }
	
	/// The number of degrees from exactness.
	var remainder: Double {
		switch self {
		case .conjunction(let remainder):
			return remainder
		case .sextile(let remainder):
			return remainder
		case .square(let remainder):
			return remainder
		case .trine(let remainder):
			return remainder
		case .opposition(let remainder):
			return remainder
		}
	}

    var isConjunction: Bool {
        switch self {
        case .conjunction(_):
            return true
        default:
            return false
        }
    }

    var isSextile: Bool {
        switch self {
        case .sextile(_):
            return true
        default:
            return false
        }
    }

    var isSquare: Bool {
        switch self {
        case .square(_):
            return true
        default:
            return false
        }
    }

    var isTrine: Bool {
        switch self {
        case .trine(_):
            return true
        default:
            return false
        }
    }

    var isOpposition: Bool {
        switch self {
        case .opposition(_):
            return true
        default:
            return false
        }
    }
}
