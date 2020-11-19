//
//  RestaurantStruct.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import Foundation

struct CityListStruct: Codable {
    let locationSuggestions: [CityStruct]

    private enum CodingKeys: String, CodingKey {
        case locationSuggestions = "location_suggestions"
    }
}

struct CityStruct: Codable {
    let id: Int
    let name: String
}
