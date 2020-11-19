//
//  RestaurantStruct.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import Foundation

struct RestaurantListStruct: Codable {
    let resultsFound, resultsStart, resultsShown: Int
    let restaurants: [RestaurantElementStruct]

    enum CodingKeys: String, CodingKey {
        case resultsFound = "results_found"
        case resultsStart = "results_start"
        case resultsShown = "results_shown"
        case restaurants
    }
}

struct RestaurantElementStruct: Codable {
    let restaurant: RestaurantStruct
}

struct RestaurantStruct: Codable {
    let id: String
    let name: String
    let cuisines: String
    let thumb: String
    let location: LocationStruct
    let priceRange: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, location, cuisines, thumb
        case priceRange = "price_range"
    }
}

struct LocationStruct: Codable {
    let address, latitude, longitude: String
}
