//
//  Restaurants.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

final class RestaurantsViewModel: ViewModelBase {
    private let _restaurantWebService: RestaurantWebService
    private let _restaurantDatabaseService: RestaurantDatabaseService
    private var _locationService: LocationService

    private var _userLocation = (lat: "", long: "")
    private(set) var restaurantList = DynamicValueList<Restaurant>()
    
    private var _restaurantStartCount = 1
    private let _numberOfRestaurantsPerCall = 20
    private var _canFetchMoreRestaurants = true
    
    private(set) lazy var fetchMoreRestaurantsCommand = Command(_fetchRestaurants, canExecute: _canExecute)
    private(set) lazy var favoriteRestaurantCommand = WpCommand(_favoriteRestaurant)
    
    init(restaurantWebService: RestaurantWebService, locationService: LocationService, restaurantDatabaseService: RestaurantDatabaseService) {
        _restaurantWebService = restaurantWebService
        _restaurantDatabaseService = restaurantDatabaseService
        _locationService = locationService
    }
    
    override func initialize() {
        _getUserLocation()
    }
    
    private func _getUserLocation() {
        if !_locationService.checkUserAuthorization() {
           _requestUserLocation()
        }
        
        let locationNotification = _locationService.getUserLocation()
        
        locationNotification.addAndNotify(observer: "location") { [weak self] in
            guard let self = self else { return }
            
            guard let location = locationNotification.value else {
                print("Please enable app location services in settings.")
                return
            }
            
            if(self._userLocation != location) {
                self._getRestaurantsIn(location: location)
                
            }
        }
    }
    
    private func _requestUserLocation() {
        if !_locationService.requestUserAuthorization() {
            print("Please enable location services on your phone.")
        }
    }
    
    private func _getRestaurantsIn(location: (lat: String, long: String)) {
        _userLocation = location
        _restaurantStartCount = 1
        _canFetchMoreRestaurants = true
        restaurantList.removeAll()
        
        _fetchRestaurants()
    }
    
    private func _fetchRestaurants() {
        guard _canFetchMoreRestaurants else { return }
        
        self.isBusy.value = true
        
        let query = [
            "start": String(_restaurantStartCount),
            "count": String(_numberOfRestaurantsPerCall),
            "lat": _userLocation.lat,
            "lon": _userLocation.long,
            "sort": "real_distance"
        ]
        
        _restaurantWebService.getRestaurants(query: query) { [weak self] (result: Result<RestaurantListObject?, WebServiceError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let restaurantList):
                guard let restaurantList = restaurantList else { return }
                self._addRestaurantsToList(restaurantList)
            case .failure( let error):
                print("Display error: \(error)")
            }
            
            self.isBusy.value = false
        }
    }
    
    private func _addRestaurantsToList(_ restaurants: RestaurantListObject) {
        guard restaurants.resultsShown > 0 else {
            _canFetchMoreRestaurants = false
            _displayReasonForNotAddingRestaurants()
            return
        }
        
        _increaseRestaurantStartCount(with: restaurants.resultsShown)
        
        let newRestaurantList = restaurants.restaurants.map { val -> Restaurant in
            Restaurant(val.restaurant)
        }
        
        restaurantList.addAll(newRestaurantList)
    }
    
    private func _displayReasonForNotAddingRestaurants() {
        if restaurantList.data.value.isEmpty {
            print("We could not find restaurants in your location :/")
        } else {
            print("We could not find more restaurants.")
        }
    }
    
    private func _increaseRestaurantStartCount(with restaurantCount: Int) {
        _restaurantStartCount += restaurantCount
    }
    
    private func _favoriteRestaurant(_ restaurantId: String) {
        let index = restaurantList.data.value.firstIndex {
            $0.getId() == restaurantId
        }
        
        guard let safeIndex = index else { return }
        
        restaurantList.data.value[safeIndex].tuggleFavorite()
        
        let restaurant = restaurantList.data.value[safeIndex]
        
        if restaurant.isFavorite() {
            _saveRestaurantInDatabase(restaurant)
        } else {
            _restaurantDatabaseService.removeFavorite(restaurant.getId())
        }
    }
    
    private func _saveRestaurantInDatabase(_ restaurant: Restaurant) {
        let restaurantImageData = ImageCache.shared.getImageData(from: restaurant.getThumbnail())
        
        let restaurantDBO = RestaurantDBObject(
            id: restaurant.getId(),
            name: restaurant.getName(),
            cousine: restaurant.getCuisines(),
            priceRange: restaurant.getPriceRange(),
            rating: restaurant.getRating() ?? "",
            lat: restaurant.getLocation().lat,
            long: restaurant.getLocation().long,
            timings: restaurant.getTiming(),
            image: restaurantImageData
        )
        
        _restaurantDatabaseService.saveFavorite(restaurantDBO)
    }
    
    private func _canExecute() -> Bool {
        return !self.isBusy.value
    }
}

