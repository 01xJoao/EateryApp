//
//  RestaurantStruct.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import Foundation

struct RestaurantListObject: Codable {
    let resultsFound, resultsStart, resultsShown: Int
    let restaurants: [RestaurantElementObject]

    enum CodingKeys: String, CodingKey {
        case resultsFound = "results_found"
        case resultsStart = "results_start"
        case resultsShown = "results_shown"
        case restaurants
    }
}

struct RestaurantElementObject: Codable {
    let restaurant: RestaurantObject
}

struct RestaurantObject: Codable, Hashable {
    let id: String
    let name: String
    let cuisines: String
    let thumb: String
    let location: LocationObject
    let userRating: UserRatingObject
    let priceRange: Int
    let timings: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, location, cuisines, thumb, timings
        case priceRange = "price_range"
        case userRating = "user_rating"
    }
}

struct LocationObject: Codable, Hashable {
    let address, latitude, longitude: String
}

struct UserRatingObject: Codable, Hashable {
    let aggregateRating: AggregateRating

    enum CodingKeys: String, CodingKey {
        case aggregateRating = "aggregate_rating"
    }
}

enum AggregateRating: Codable, Hashable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        
        throw DecodingError.typeMismatch(AggregateRating.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AggregateRating"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
