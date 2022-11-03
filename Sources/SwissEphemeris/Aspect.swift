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
    /// A 30° alignment.
    case semisextile
    /// A 45° alignment.
    case semisquare
    /// A 60° alignment.
    case sextile
    /// A 90° alignment.
    case square
    /// A 120° alignment.
    case trine
    /// An 135° alignment.
    case sesiquadrate
    /// A 150° alignment.
    case inconjunction
    /// An 180° alignment.
    case opposition
}

public struct CelestialAspect: Codable, Equatable, Hashable {

    public let kind: Kind
    public let body1: Coordinate
    public let body2: Coordinate
    public let angle: Double

    public var orbDelta: Double {
        switch kind {
        case .conjunction:
            return angle
        case .semisextile:
            return preciseRound(angle - 30.0, precision: .thousandths)
        case .semisquare:
            return preciseRound(angle - 45.0, precision: .thousandths)
        case .sextile:
            return preciseRound(angle - 60.0, precision: .thousandths)
        case .square:
            return preciseRound(angle - 90.0, precision: .thousandths)
        case .trine:
            return preciseRound(angle - 120.0, precision: .thousandths)
        case .sesiquadrate:
            return preciseRound(angle - 135.0, precision: .thousandths)
        case .inconjunction:
            return preciseRound(angle - 150.0, precision: .thousandths)
        case .opposition:
            return preciseRound(angle - 180.0, precision: .thousandths)
        }
    }

    public var aspectString: String {
        return "\(body1.body) \(kind) \(body2.body) with orb: \(orbDelta)"
    }

    public init?(body1: Coordinate, body2: Coordinate, orb: Double) {
        if let a = Aspect(a: body1.longitude, b: body2.longitude, orb: orb) {
            self.body1 = body1
            self.body2 = body2

            switch a {
            case .conjunction(_):
                self.angle = 0.0 + a.remainder
                self.kind = .conjunction
            case .semisextile(_):
                self.angle = 30.0 + a.remainder
                self.kind = .semisextile
            case .semisquare(_):
                self.angle = 45.0 + a.remainder
                self.kind = .semisquare
            case .sextile(_):
                self.angle = 60.0 + a.remainder
                self.kind = .sextile
            case .square(_):
                self.angle = 90.0 + a.remainder
                self.kind = .square
            case .trine(_):
                self.angle = 120.0 + a.remainder
                self.kind = .trine
            case .sesiquadrate(_):
                self.angle = 135.0 + a.remainder
                self.kind = .sesiquadrate
            case .inconjunction(_):
                self.angle = 150.0 + a.remainder
                self.kind = .inconjunction
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
        return test1 || test2 || test3
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(body1.date)
        hasher.combine(body1.latitude)
        hasher.combine(body1.longitude)
        hasher.combine(body1.value)
        hasher.combine(body2.date)
        hasher.combine(body2.latitude)
        hasher.combine(body2.longitude)
        hasher.combine(body2.value)
        hasher.combine(angle)
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
    /// A 30° alignment.
    case semisextile(Double)
    /// A 45° alignment.
    case semisquare(Double)
    /// A 60° alignment.
    case sextile(Double)
    /// A 90° alignment.
    case square(Double)
    /// A 120° alignment.
    case trine(Double)
    /// A 135° alignment.
    case sesiquadrate(Double)
    /// A 150° alignment.
    case inconjunction(Double)
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

        let aspectValue = abs(b - a) >= 180 ? abs(abs(b - a) - 360) : abs(b - a)
        switch aspectValue {
        case (0 - orb)...(0 + orb):
            self = .conjunction(preciseRound(aspectValue, precision: .hundredths))
        case (30 - orb)...(30 + orb):
            self = .semisextile(preciseRound((aspectValue - 30), precision: .hundredths))
        case (45 - orb)...(45 + orb):
            self = .semisquare(preciseRound((aspectValue - 45), precision: .hundredths))
        case (60 - orb)...(60 + orb):
            self = .sextile(preciseRound((aspectValue - 60), precision: .hundredths))
        case (90 - orb)...(90 + orb):
            self = .square(preciseRound((aspectValue - 90), precision: .hundredths))
        case (120 - orb)...(120 + orb):
            self = .trine(preciseRound((aspectValue - 120), precision: .hundredths))
        case (135 - orb)...(135 + orb):
            self = .sesiquadrate(preciseRound((aspectValue - 135), precision: .hundredths))
        case (150 - orb)...(150 + orb):
            self = .inconjunction(preciseRound((aspectValue - 150), precision: .hundredths))
        case (180 - orb)...(180 + orb):
            self = .opposition(preciseRound((aspectValue - 180), precision: .hundredths))
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

	/// The symbol commonly associated with the aspect.
    public var symbol: String? {
        switch self {
        case .conjunction:
            return "☌ (prominence)"
        case .semisextile:
            return "growth"
        case .semisquare:
            return "friction"
        case .sextile:
            return "﹡ (opportunity)"
        case .square:
            return "◾️ (obstacle)"
        case .trine:
            return "▵ (luck)"
        case .sesiquadrate:
            return "agitation"
        case .inconjunction:
            return "expansion"
        case .opposition:
            return "☍ (separation)"
        }
    }
	
	/// The number of degrees from exactness.
	var remainder: Double {
		switch self {
        case .conjunction(let remainder):
            return remainder
        case .semisextile(let remainder):
            return remainder
        case .semisquare(let remainder):
            return remainder
        case .sextile(let remainder):
            return remainder
        case .square(let remainder):
            return remainder
        case .trine(let remainder):
            return remainder
        case .sesiquadrate(let remainder):
            return remainder
        case .inconjunction(let remainder):
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

    var isSemisextile: Bool {
        switch self {
        case .semisextile(_):
            return true
        default:
            return false
        }
    }

    var isSemisquare: Bool {
        switch self {
        case .semisquare(_):
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

    var isSesiquadrate: Bool {
        switch self {
        case .sesiquadrate(_):
            return true
        default:
            return false
        }
    }

    var isInconjunction: Bool {
        switch self {
        case .inconjunction(_):
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
