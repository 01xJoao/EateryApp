//
//  DatabaseRestaurantService.swift
//  Eatery
//
//  Created by João Palma on 21/11/2020.
//

import Foundation

protocol RestaurantDatabaseService {
    func getFavorites() -> [Favorite]
    func saveFavorite(_ restaurant: RestaurantDataDBO)
    func removeFavorite(_ resturantId: String)
}
