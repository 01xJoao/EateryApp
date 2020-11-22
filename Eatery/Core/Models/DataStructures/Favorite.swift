//
//  Favorite.swift
//  Eatery
//
//  Created by João Palma on 20/11/2020.
//

import Foundation

struct Favorite {
    private let _restaurant: RestaurantDBObject
    
    init(_ restaurant: RestaurantDBObject) {
        _restaurant = restaurant
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
    
    func getPriceScale() -> String {
        _restaurant.priceRange
    }
    
    func getDistance() -> String {
        return "3 km"
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
