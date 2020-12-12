//
//  Favorite.swift
//  Eatery
//
//  Created by João Palma on 20/11/2020.
//

import Foundation

struct Favorite {
    private let _restaurant: RestaurantData
    private var _distance: String = ""
    
    init(_ restaurant: RestaurantData) {
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
    
    func getLatitude() -> String {
        _restaurant.lat
    }
    
    func getLongitude() -> String {
        _restaurant.long
    }
    
    mutating func setDistance(_ distance: String) {
        _distance = distance
    }
}
