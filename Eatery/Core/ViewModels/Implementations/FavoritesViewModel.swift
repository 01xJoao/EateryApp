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
    
    private(set) lazy var unfavoriteRestaurantCommand = WpCommand(_unfavoriteRestaurant)
    
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
    
    private func _unfavoriteRestaurant(restaurantId: String) {
        let index = favoriteList.data.value.firstIndex {
            $0.getId() == restaurantId
        }
        
        guard let safeIndex = index else { return }
        
        favoriteList.remove(at: safeIndex)
        _restaurantDatabaseService.removeFavorite(restaurantId)
    }
}
