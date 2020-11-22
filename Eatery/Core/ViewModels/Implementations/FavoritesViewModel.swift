//
//  Favorites.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

final class FavoritesViewModel: ViewModelBase {
    private let _restaurantDatabaseService: RestaurantDatabaseService
    
    private(set) var favoriteList = DynamicValueList<Favorite>()
    
    init(restaurantDatabaseService: RestaurantDatabaseService) {
        _restaurantDatabaseService = restaurantDatabaseService
    }
    
    override func appearing() {
        _getFavoriteRestaurants()
    }
    
    private func _getFavoriteRestaurants() {
        favoriteList.removeAll()
        
        let favoritesDBO = _restaurantDatabaseService.getFavorites()
        let favoriteRestaurants = favoritesDBO.map { Favorite($0) }
        
        favoriteList.addAll(favoriteRestaurants)
    }
}
