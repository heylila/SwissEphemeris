//
//  Aspect.swift
//  
//
//  29.08.20.
//

import Foundation

public enum Kind: Codable, CaseIterable {
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

public struct CelestialAspect: Codable, Equatable, Hashable {

    public let kind: Kind
    public let body1: Coordinate
    public let body2: Coordinate
    public let angle: Double
    public let orb: Double

    public var orbDelta: Double {
        switch kind {
        case .conjunction:
            return angle
        case .sextile:
            return preciseRound(angle - 60.0, precision: .thousandths)
        case .square:
            return preciseRound(angle - 90.0, precision: .thousandths)
        case .trine:
            return preciseRound(angle - 120.0, precision: .thousandths)
        case .opposition:
            return preciseRound(angle - 180.0, precision: .thousandths)
        }
    }

    public var aspectString: String {
        return "\(body1.body) \(kind) \(body2.body) with orb: \(orbDelta)"
    }

    public init?(body1: CelestialObject, body2: CelestialObject, date: Date, orb: Double) {
        let TBody1 = Coordinate(body: body1, date: date)
        let TBody2 = Coordinate(body: body2, date: date)
        self.init(body1: TBody1, body2: TBody2, orb: orb)
    }

    public init?(body1: Coordinate, body2: Coordinate, orb: Double) {
        if let a = Aspect(a: body1.longitude, b: body2.longitude, orb: orb) {
            self.body1 = body1
            self.body2 = body2
            self.orb = orb

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

    public func shortDebug() -> String {
        let body1Name = String(describing: body1.body.formatted)
        let body2Name = String(describing: body2.body.formatted)
        let aspect = String("\(kind)")
        let body1TimeStamp = body1.date.toString(format: .cocoaDateTime)!
        let body2TimeStamp = body2.date.toString(format: .cocoaDateTime)!
        return "\(body1Name) at \(body1TimeStamp) makes \(aspect) with \(body2Name) at \(body2TimeStamp)"
    }

    public static func ==(lhs: CelestialAspect, rhs: CelestialAspect) -> Bool {
        let test1 = (lhs.body1 == rhs.body1 &&
                     lhs.body2 == rhs.body2 &&
                     lhs.kind == rhs.kind &&
                     lhs.angle == rhs.angle)
        let test2 = (lhs.body1.formatted == rhs.body2.formatted &&
                     lhs.kind == rhs.kind &&
                     lhs.angle == rhs.angle)
        let test3 = (lhs.body2.formatted == lhs.body1.formatted &&
                     lhs.kind == rhs.kind &&
                     lhs.angle == rhs.angle)

        // CONCERN: The only thing that I DON'T KNOW here is if
        // two of the same bodies that make the same aspect NOW
        // could be considered identity-wise to make the same aspect at the same
        // angle+orb in the distant future or distant past.
        // My intuition tells me "no" but that's not really what's being tested here
        func testEqualityWithOrb() -> Bool {
            let lhsRange = (lhs.angle - lhs.orb)...(lhs.angle + lhs.orb)
            let rhsRange = (rhs.angle - rhs.orb)...(rhs.angle + rhs.orb)
            let angleWithOrbTest = lhsRange.overlaps(rhsRange)

            return (lhs.body1.body == rhs.body1.body &&
                    lhs.body2.body == rhs.body2.body &&
                    lhs.kind == rhs.kind &&
                    angleWithOrbTest)
        }

        let test4 = testEqualityWithOrb()

        return test1 || test2 || test3 || test4
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(body1.date)
        hasher.combine(body1.latitude)
        hasher.combine(body1.longitude)
        hasher.combine(body1.value)
        hasher.combine(body1.body)
        hasher.combine(body2.date)
        hasher.combine(body2.latitude)
        hasher.combine(body2.longitude)
        hasher.combine(body2.value)
        hasher.combine(body2.body)
        hasher.combine(angle)
        hasher.combine(kind)
    }
}

public struct CuspAspect: Codable, Equatable, Hashable {

    public let kind: Kind
    public let body: Coordinate
    public let cusp: Cusp
    public let angle: Double

    public var orbDelta: Double {
        switch kind {
        case .conjunction:
            return angle
        case .sextile:
            return preciseRound(angle - 60.0, precision: .thousandths)
        case .square:
            return preciseRound(angle - 90.0, precision: .thousandths)
        case .trine:
            return preciseRound(angle - 120.0, precision: .thousandths)
        case .opposition:
            return preciseRound(angle - 180.0, precision: .thousandths)
        }
    }

    public var aspectString: String {
        return "\(body.body) \(kind) \(cusp.name) with orb: \(orbDelta)"
    }

    public init?(body: Coordinate, cusp: Cusp, orb: Double) {
        if let a = Aspect(body: body, cusp: cusp, orb: orb) {
            self.body = body
            self.cusp = cusp

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

    public static func ==(lhs: CuspAspect, rhs: CuspAspect) -> Bool {
        let test1 = (lhs.body == rhs.body &&
                     lhs.cusp == rhs.cusp &&
                     lhs.kind == rhs.kind &&
                     lhs.angle == rhs.angle)
        let test2 = (lhs.body.formatted == rhs.body.formatted &&
                     lhs.kind == rhs.kind &&
                     lhs.angle == rhs.angle)
        let test3 = (lhs.cusp.name == lhs.cusp.name &&
                     lhs.cusp.value == rhs.cusp.value &&
                     lhs.kind == rhs.kind &&
                     lhs.angle == rhs.angle)
        return test1 || test2 || test3
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(body.date)
        hasher.combine(body.latitude)
        hasher.combine(body.longitude)
        hasher.combine(body.body)
        hasher.combine(cusp.name)
        hasher.combine(cusp.value)
        hasher.combine(angle)
        hasher.combine(kind)
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
    public init?(pair: (a: CelestialObject, b: CelestialObject), date: Date, orb: Double = 10.0) {
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

        // NOTE: I'm not a fan of rounding here in the Aspect constructor
        // because I believe this should be handled at the orb level. BUT if you're going
        // to do it, this is how you would do it:
        
        // let aValue = abs(b - a) >= 180 ? abs(abs(b - a) - 360) : abs(b - a)
        // let aspectValue = preciseRound(aValue, precision: .thousandths)

        let aspectValue = abs(b - a) >= 180 ? abs(abs(b - a) - 360) : abs(b - a)
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
    public init?(bodyA: Coordinate, bodyB: Coordinate, orb: Double = 10.0) {
        self.init(a: bodyA.longitude, b: bodyB.longitude, orb: orb)
    }

    /// Creates an optional `Aspect` between a Coordinate and a Cusp. If there is no aspect within the orb, then this initializer will return `nil`.
    /// - Parameters:
    ///   - body: The body of the aspect.
    ///   - cusp: The cusp of the aspect
    ///   - orb: The number of degrees allowed for the aspect to differ from exactness.
    public init?(body: Coordinate, cusp: Cusp, orb: Double = 10.0) {
        self.init(a: body.longitude, b: cusp.value, orb: orb)
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
