//
//  Favorite.swift
//  Eatery
//
//  Created by João Palma on 20/11/2020.
//

import Foundation

struct Favorite {
    private let _restaurant: RestaurantDBObject
    private let _distance: String
    
    init(_ restaurant: RestaurantDBObject, distance: String) {
        _restaurant = restaurant
        _distance = distance
    }
    
    func getId() -> String {
        _restaurant.id
    }
    
    func getName() -> String {
        _restaurant.name
    }
    
    func getRating() -> String {
        _restaurant.rating
    }
    
    func getPriceRange() -> String {
        _restaurant.priceRange
    }
    
    func getDistance() -> String {
        _distance
    }
    
    func getThumbnail() -> Data? {
        _restaurant.image
    }
    
    func getCuisines() -> String {
        _restaurant.cousine
    }
    
    func getTiming() -> String {
        _restaurant.timings
    }
    
    func getImage() -> Data? {
        _restaurant.image
    }
}
