//
//  Coordinate.swift
//  
//
//  Created by Vincent Smithers on 10.02.21.
//

import Foundation
import CSwissEphemeris


/// Models a `CelestialBody` point in the sky.
public struct Coordinate<T: CelestialBody>: Equatable {
	
	/// The type of `CelestialBody`.
	public let body: T
	/// The date of the the coordinate.
	public let date: Date
	/// The coordinate's longitude.
	public let longitude: Double
	/// The coordinate's latitude.
	public let latitude: Double
    /// The computed angle between the celestial body and the heavenly equator.
    public let declination: Double
    /// The distance in AU.
	public let distance: Double
	/// The speed in longitude (deg/day).
	public let speedLongitude: Double
	/// The speed in latitude (deg/day).
	public let speedLatitude: Double
	/// The speed in distance (AU/day).
	public let speedDistance: Double
	/// The pointer that holds all values.
	private var pointer = UnsafeMutablePointer<Double>.allocate(capacity: 6)
	/// The pointer for the fixed star name.
	private var charPointer = UnsafeMutablePointer<CChar>.allocate(capacity: 1)

    public static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return (lhs.body == rhs.body &&
                lhs.date == rhs.date &&
                lhs.longitude == rhs.longitude &&
                lhs.latitude == rhs.latitude &&
                lhs.declination == rhs.declination &&
                lhs.distance == rhs.distance &&
                lhs.speedLongitude == rhs.speedLongitude &&
                lhs.speedDistance == rhs.speedDistance)
    }

    public static func !=(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return (lhs.body != rhs.body ||
                lhs.date != rhs.date ||
                lhs.longitude != rhs.longitude ||
                lhs.latitude != rhs.latitude ||
                lhs.declination != rhs.declination ||
                lhs.distance != rhs.distance ||
                lhs.speedLongitude != rhs.speedLongitude ||
                lhs.speedDistance != rhs.speedDistance)
    }

	/// Creates a `Coordinate`.
	/// - Parameters:
	///   - body: The `CelestialBody` for the placement.
	///   - date: The date for the location of the coordinate.
	public init(body: T, date: Date) {
        defer {
            pointer.deinitialize(count: 6)
            pointer.deallocate()
            if let star = body as? FixedStar {
                charPointer.deinitialize(count: star.rawValue.count)
                charPointer.deallocate()
            }
        }
		self.body = body
		self.date = date
        let isMeanSouthNode = (body is LunarNode && body as! LunarNode == .meanSouthNode)
        let isTrueSouthNode = (body is LunarNode && body as! LunarNode == .trueSouthNode)
		switch body.value {
		case let value as Int32:
            pointer.initialize(repeating: 0, count: 6)
            let calcValue: Int32
            if isMeanSouthNode {
                calcValue = Int32(LunarNode.meanNode.rawValue)
            }
            else if isTrueSouthNode {
                calcValue = Int32(LunarNode.trueNode.rawValue)
            }
            else {
                calcValue = value
            }

            swe_calc_ut(date.julianDate(), calcValue, SEFLG_SPEED, pointer, nil)
		case let value as String:
			charPointer.initialize(from: value, count: value.count)
			charPointer = strdup(value)
			swe_fixstar2(charPointer, date.julianDate(), SEFLG_SPEED, pointer, nil)
		default:
			break
		}

        var longDegrees = 0.0

        if isMeanSouthNode || isTrueSouthNode {
            let adjDegrees = pointer[0] + 180.0
            longDegrees = adjDegrees >= 360.0 ? (pointer[0] - 180.0) : adjDegrees
        }

        longitude = (isMeanSouthNode || isTrueSouthNode) ? longDegrees : pointer[0]
        latitude = pointer[1]
        declination = Coordinate.calculateDeclination(latitude, longitude)
		distance = pointer[2]
		speedLongitude = pointer[3]
		speedLatitude = pointer[4]
		speedDistance = pointer[5]
	}

    private static func calculateDeclination(_ lat: Double, _ lng: Double) -> Double {
        // Formula: sin D = (cos B x sin L x sin E) + (sin B x cos E)
        // Where:
        // D = Declination (what we are solving for)
        // E = The oblique angle of the ecliptic (Epsilon or ~23.447 degrees)
        // L = Longitude measured from 0 degrees Aries
        // B = Latitude

        let epsilon = 23.437101628
        func deg2rad(_ number: Double) -> Double { return number * .pi / 180 }
        func rad2deg(_ number: Double) -> Double { return number * 180 / .pi }
        let B = deg2rad(lat)
        let L = deg2rad(lng)
        let E = deg2rad(epsilon)
        let lhs = cos(B) * sin(L) * sin(E)
        let rhs = sin(B) * cos(E)
        let sum = lhs + rhs
        let dec = rad2deg(asin(sum))
        return dec
    }

    public func declinationString() -> String {
        let degree = Int(declination)
        let arcminute = Int((declination - Double(degree)) * 60)
        let arcsecond = Int(declination - Double(degree) - Double(arcminute / 60) * 3600)
        return "\(degree)°\(arcminute)\'\(arcsecond)\""
    }
}

// MARK: - ZodiacCoordinate Conformance

extension Coordinate: ZodiacCoordinate {
	public var value: Double { longitude }
}

// MARK: - Codable Conformance

extension Coordinate: Codable {
    
    public enum CodingKeys: CodingKey {
        case body
        case date
        case longitude
        case latitude
        case declination
        case distance
        case speedLongitude
        case speedLatitude
        case speedDistance
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = try container.decode(T.self, forKey: .body)
        date = try container.decode(Date.self, forKey: .date)
        longitude = try container.decode(Double.self, forKey: .longitude)
        latitude = try container.decode(Double.self, forKey: .latitude)
        declination = try container.decode(Double.self, forKey: .declination)
        distance = try container.decode(Double.self, forKey: .distance)
        speedLongitude = try container.decode(Double.self, forKey: .speedLongitude)
        speedLatitude = try container.decode(Double.self, forKey: .speedLatitude)
        speedDistance = try container.decode(Double.self, forKey: .speedDistance)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(body, forKey: .body)
        try container.encode(date, forKey: .date)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(distance, forKey: .distance)
        try container.encode(speedLongitude, forKey: .speedLongitude)
        try container.encode(speedLatitude, forKey: .speedLatitude)
        try container.encode(speedDistance, forKey: .speedDistance)
    }

    public func longitudeDelta<Body>(other: Coordinate<Body>) -> Double {
        return abs(longitude - other.longitude)
    }
}
