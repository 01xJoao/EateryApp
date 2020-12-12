//
//  RestaurantDBObject.swift
//  Eatery
//
//  Created by João Palma on 21/11/2020.
//

import CoreData

class RestaurantData: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var cousine: String
    @NSManaged var priceRange: String
    @NSManaged var rating: String
    @NSManaged var lat: String
    @NSManaged var long: String
    @NSManaged var timings: String
    @NSManaged var image: Data?
    
    func fillData(with restaurant: RestaurantDataDBO) {
        self.id = restaurant.id
        self.name = restaurant.name
        self.cousine = restaurant.cousine
        self.priceRange = restaurant.priceRange
        self.rating = restaurant.rating
        self.lat = restaurant.lat
        self.long = restaurant.long
        self.timings = restaurant.timings
        self.image = restaurant.image
    }
}

struct RestaurantDataDBO {
    let id: String
    let name: String
    let cousine: String
    let priceRange: String
    let rating: String
    let lat: String
    let long: String
    let timings: String
    let image: Data?
}
