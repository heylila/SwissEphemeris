//
//  AsymAspect.swift
//  
//
//  Created by Sam Krishna on 1/21/23.
//

import Foundation

//      ONLY for Natal Aspects
//      angular > succeedent > cadent
public enum HouseKind: Codable, CaseIterable {
    /// A 1/4/7/10 House Placement
    case angular
    /// A 2/5/8/11 House Placement
    case succedent
    /// A 3/6/9/12 House Placement
    case cadent
}


//    var angular_conjunction = 12.0
//    var angular_semisextile = 3.0
//    var angular_sextile = 7.0
//    var angular_square = 10.0
//    var angular_trine = 10.0
//    var angular_inconjunct = 3.0
//    var angular_semisquare = 5.0
//    var angular_sesquisquare = 5.0
//    var angular_opposition = 12.0
//
//
//    var lum_angular_conjunction = 15.0
//    var lum_angular_semisextile = 4.0
//    var lum_angular_sextile = 8.0
//    var lum_angular_square = 12.0
//    var lum_angular_trine = 12.0
//    var lum_angular_inconjunct = 4.0
//    var lum_angular_semisquare = 6.0
//    var lum_angular_sesquisquare = 6.0
//    var lum_angular_opposition = 15.0
//
//
//    var cadent_conjunction = 8.0
//    var cadent_semisextile = 1.0
//    var cadent_sextile = 5.0
//    var cadent_square = 6.0
//    var cadent_trine = 6.0
//    var cadent_inconjunct = 1.0
//    var cadent_semisquare = 3.0
//    var cadent_sesquisquare = 3.0
//    var cadent_opposition = 8.0
//
//    var lum_cadent_conjunction = 11.0
//    var lum_cadent_semisextile = 2.0
//    var lum_cadent_sextile = 6.0
//    var lum_cadent_square = 10.0
//    var lum_cadent_trine = 8.0
//    var lum_cadent_inconjunct = 2.0
//    var lum_cadent_semisquare = 4.0
//    var lum_cadent_sesquisquare = 4.0
//    var lum_cadent_opposition = 11.0
//
//
//    var succedent_conjunction = 10.0
//    var succedent_semisextile = 2.0
//    var succedent_sextile = 6.0
//    var succedent_square = 8.0
//    var succedent_trine = 8.0
//    var succedent_inconjunct = 2.0
//    var succedent_semisquare = 4.0
//    var succedent_sesquisquare = 4.0
//    var succedent_opposition = 10.0
//
//    var lum_succedent_conjunction = 13.0
//    var lum_succedent_semisextile = 3.0
//    var lum_succedent_sextile = 7.0
//    var lum_succedent_square = 10.0
//    var lum_succedent_trine = 10.0
//    var lum_succedent_inconjunct = 3.0
//    var lum_succedent_semisquare = 5.0
//    var lum_succedent_sesquisquare = 5.0
//    var lum_succedent_opposition = 13.0

