//
//  HouseCusps.swift
//  
//
//  26.12.19.
//

import CSwissEphemeris
import Foundation

/// Models a house system with a `Cusp` for each house, ascendent and midheaven.
public struct HouseCusps {

    /// The time at which the house system is valid
    public let date: Date
    /// The latitude of the house system
    public let latitude: Double
    /// The longitude of the house system
    public let longitude: Double
    /// The pointer passed into `set_house_system(julianDate, latitude, longitude, ascendentPointer, cuspPointer)`
    /// `ascPointer` argument
    private let ascendentPointer = UnsafeMutablePointer<Double>.allocate(capacity: 10)
    /// The pointer passed into `set_house_system(julianDate, latitude, longitude, ascendentPointer, cuspPointer)`
    /// `cuspPointer` argument
    /// This is not used because it is not relevant to ascendent data
    private let cuspPointer = UnsafeMutablePointer<Double>.allocate(capacity: 13)
    /// Point of ascendent
	public let ascendent: Cusp
    /// Point of MC
    public let midHeaven: Cusp
    /// Cusp between twelth and first house
    public let first: Cusp
    /// Cusp between first and second house
    public let second: Cusp
    /// Cusp between second and third house
    public let third: Cusp
    /// Cusp between third and fourth house
    public let fourth: Cusp
    /// Cusp between fourth and fifth house
    public let fifth: Cusp
    /// Cusp between fifth and sixth house
    public let sixth: Cusp
    /// Cusp between sixth and seventh house
    public let seventh: Cusp
    /// Cusp between seventh and eighth house
    public let eighth: Cusp
    /// Cusp between eighth and ninth house
    public let ninth: Cusp
    /// Cusp between the ninth and tenth house
    public let tenth: Cusp
    /// Cusp between the tenth and eleventh house
    public let eleventh: Cusp
    /// Cusp between the eleventh and twelfth house
    public let twelfth: Cusp

    /// Array of House Cusps, by numerical order
    public let houses: [Cusp]

    /// Sign of Aries with starting degree
    public let aries: Sign
    /// Sign of Taurus with starting degree
    public let taurus: Sign
    /// Sign of Gemini with starting degree
    public let gemini: Sign
    /// Sign of Cancer with starting degree
    public let cancer: Sign
    /// Sign of Leo with starting degree
    public let leo: Sign
    /// Sign of Virgo with starting degree
    public let virgo: Sign
    /// Sign of Libra with starting degree
    public let libra: Sign
    /// Sign of Scorpio with starting degree
    public let scorpio: Sign
    /// Sign of Sagittarius with starting degree
    public let sagittarius: Sign
    /// Sign of Capricorn with starting degree
    public let capricorn: Sign
    /// Sign of Aquarius with starting degree
    public let aquarius: Sign
    /// Sign of Pisces with starting degree
    public let pisces: Sign

    /// Array of House Signs, by Zodiac order
    public let signs: [Sign]

	/// The preferred initializer
	/// - Parameters:
	///   - date: The date for the houses to be laid out
	///   - latitude: The location latitude for the house system
	///   - longitude: The locations longitude for the house system
	///   - houseSystem: The type of `HouseSystem`.
    public init(date: Date,
                latitude: Double,
				longitude: Double,
				houseSystem: HouseSystem) {
		defer {
			cuspPointer.deallocate()
			ascendentPointer.deallocate()
		}
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
		swe_houses(date.julianDate(), latitude, longitude, houseSystem.rawValue, cuspPointer, ascendentPointer);
        ascendent = Cusp(value: ascendentPointer[0], name: "ascendant", number: 1)
        midHeaven = Cusp(value: ascendentPointer[1], name: "midHeaven", number: 10)
        first = Cusp(value: cuspPointer[1], name: "first", number: 1)
        second = Cusp(value: cuspPointer[2], name: "second", number: 2)
        third = Cusp(value: cuspPointer[3], name: "third", number: 3)
        fourth =  Cusp(value: cuspPointer[4], name: "fourth", number: 4)
        fifth = Cusp(value: cuspPointer[5], name: "fifth", number: 5)
        sixth = Cusp(value: cuspPointer[6], name: "sixth", number: 6)
        seventh = Cusp(value: cuspPointer[7], name: "seventh", number: 7)
        eighth =  Cusp(value: cuspPointer[8], name: "eighth", number: 8)
        ninth =  Cusp(value: cuspPointer[9], name: "ninth", number: 9)
        tenth = Cusp(value: cuspPointer[10], name: "tenth", number: 10)
        eleventh = Cusp(value: cuspPointer[11], name: "eleventh", number: 11)
        twelfth =  Cusp(value: cuspPointer[12], name: "twelfth", number: 12)

        houses = [
            first, second, third, fourth, fifth, sixth,
            seventh, eighth, ninth, tenth, eleventh, twelfth
        ]

        let origin = 360.0 - ascendent.value
        aries = Sign(value: origin, houseNumber: 0)
        taurus = Sign(value: origin + 30.0, houseNumber: 1)
        gemini = Sign(value: origin + 60.0, houseNumber: 2)
        cancer = Sign(value: origin + 90.0, houseNumber: 3)
        leo = Sign(value: origin + 120.0, houseNumber: 4)
        virgo = Sign(value: origin + 150.0, houseNumber: 5)
        libra = Sign(value: origin + 180.0, houseNumber: 6)
        scorpio = Sign(value: origin + 210.0, houseNumber: 7)
        sagittarius = Sign(value: origin + 240.0, houseNumber: 8)
        capricorn = Sign(value: origin + 270.0, houseNumber: 9)
        aquarius = Sign(value: origin + 300.0, houseNumber: 10)
        pisces = Sign(value: origin + 330.0, houseNumber: 11)

        signs = [
            aries, taurus, gemini, cancer, leo, virgo,
            libra, scorpio, sagittarius, capricorn, aquarius, pisces
        ]
    }

    public func cuspForLongitude(_ coordinate: Double) -> Cusp? {
        if coordinate >= 360.0 { return nil }
        let offsetHouses = Array(houses.dropFirst()) + [first]
        var pair: (current: Cusp, next: Cusp)?

        for (current, next) in zip(houses, offsetHouses) {
            // Marking things VERY explicitly with parentheses in order to preserve intended computational expression units
            let sector = (current.value < next.value) ? current.value..<next.value : (current.value - 360.0)..<next.value

            // This is a nested tertiary operation (essentially, a tertiary operator inside a tertiary operator)
            // Being SUPER-explicit because of the rollover logic required to handle a house that crosses 0 degrees
            let newLongitude = (current.value < next.value) ? coordinate : ((coordinate > current.value) ? (coordinate - 360.0) : coordinate)

            if sector.contains(newLongitude) {
                pair = (current, next)
                break
            }
        }

        guard let pair = pair else { return nil }
        return pair.current
    }
}
