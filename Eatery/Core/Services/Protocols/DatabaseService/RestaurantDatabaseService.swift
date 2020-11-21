//
//  DatabaseRestaurantService.swift
//  Eatery
//
//  Created by João Palma on 21/11/2020.
//

import Foundation

protocol RestaurantDatabaseService where Self:RestaurantDatabaseServiceImp {
    func getFavorites() -> [RestaurantDBObject]
    func saveFavorite(_ restaurant: RestaurantDBObject)
    func removeFavorite(_ resturantId: String)
}
