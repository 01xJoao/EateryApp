//
//  RestaurantDBObject.swift
//  Eatery
//
//  Created by João Palma on 21/11/2020.
//

import CoreData

struct RestaurantDBObject {
    let id: String
    let name: String
    let cousine: String
    let priceRange: String
    let rating: String
    let lat: String
    let long: String
    let timings: String
    let image: Data?
    
    init(id: String, name: String, cousine: String, priceRange: String, rating: String, lat: String, long: String, timings: String, image: Data?) {
        self.id = id
        self.name = name
        self.cousine = cousine
        self.priceRange = priceRange
        self.rating = rating
        self.lat = lat
        self.long = long
        self.timings = timings
        self.image = image
    }

    init(data: RestaurantData) {
        self.init(id: data.id!, name: data.name!, cousine: data.cousine!, priceRange: data.priceRange!, rating: data.rating!,
                  lat: data.lat!, long: data.long!, timings: data.timings!, image: data.image)
    }
}
