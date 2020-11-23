//
//  Favorites.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

final class FavoritesViewModel: ViewModelBase {
    private let _restaurantDatabaseService: RestaurantDatabaseService
    private let _locationSerivce: LocationService
    
    private(set) var favoriteList = DynamicValueList<Favorite>()
    
    private(set) lazy var unfavoriteRestaurantCommand = WpCommand(_unfavoriteRestaurant)
    private(set) lazy var navigateToRestaurantCommand = WpCommand(_navigateToRetaurant)
    
    init(restaurantDatabaseService: RestaurantDatabaseService, locationSerivce: LocationService) {
        _restaurantDatabaseService = restaurantDatabaseService
        _locationSerivce = locationSerivce
    }
    
    override func appearing() {
        _getFavoriteRestaurants()
    }
    
    private func _getFavoriteRestaurants() {
        favoriteList.removeAll()
        
        let favoritesDBO = _restaurantDatabaseService.getFavorites()
        let favoriteRestaurants = favoritesDBO.map { restaurant -> Favorite in
            let distance = _getRestaurantDistance((lat: restaurant.lat, long: restaurant.long))
            
            return Favorite(restaurant, distance: distance)
        }
        
        favoriteList.addAll(favoriteRestaurants)
    }
    
    private func _getRestaurantDistance(_ location: (lat: String, long: String)) -> String {
        let distance = _locationSerivce.getDistanceFrom(restaurantLocation: location)
        
        guard let realDistance = distance else { return "" }
        
        return Helper.getDistanceInMetrics(realDistance)
    }
    
    
    private func _unfavoriteRestaurant(restaurantId: String) {
        let index = favoriteList.data.value.firstIndex {
            $0.getId() == restaurantId
        }
        
        if let safeIndex = index {
            favoriteList.remove(at: safeIndex)
            _restaurantDatabaseService.removeFavorite(restaurantId)
        }
    }
    
    private func _navigateToRetaurant(restaurantId: String) {
        let favoriteRestaurant = favoriteList.data.value.first { $0.getId() == restaurantId }
        navigationService.navigate(viewModel: RestaurantDetailViewModel.self, arguments: favoriteRestaurant, animated: true)
    }
    
    let favoritesTitle = I18N.localize(key: "favorites")
}
