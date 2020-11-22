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
    
    private var _restaurantStartCount = 1
    private let _numberOfRestaurantsPerCall = 20
    private var _canFetchMoreRestaurants = true
    private var _userLocation = (lat: "", long: "")
    private var _favoriteRestaurants = [String]()
    private var _search = ""
    
    private(set) var restaurantList = DynamicValueList<Restaurant>()
    private(set) var searchRestaurantList = DynamicValueList<Restaurant>()
    private(set) var isSearching = false
    private(set) var restaurantFilter = RestaurantFilter.distance
    
    private(set) lazy var fetchMoreRestaurantsCommand = Command({ self._fetchRestaurants()}, canExecute: _canExecute)
    private(set) lazy var favoriteRestaurantCommand = WpCommand(_favoriteRestaurant)
    private(set) lazy var seachRestaurantCommand = WpCommand(_searchRestaurant)
    private(set) lazy var cancelSearchRestaurantCommand = Command(_cancelSearch)
    private(set) lazy var changeFilterCommand = WpCommand(_filterRestaurants)
    
    init(restaurantWebService: RestaurantWebService, locationService: LocationService, restaurantDatabaseService: RestaurantDatabaseService) {
        _restaurantWebService = restaurantWebService
        _restaurantDatabaseService = restaurantDatabaseService
        _locationService = locationService
    }
    
    override func initialize() {
        _getFavoriteRestaurants()
        _getUserLocation()
    }
    
    override func appearing() {
        _getFavoriteRestaurants()
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
        _clearRestaurantCount()
        restaurantList.removeAll()
        
        _fetchRestaurants()
    }
    
    private func _clearRestaurantCount() {
        _restaurantStartCount = 1
        _canFetchMoreRestaurants = true
    }
    
    private func _fetchRestaurants(clearList: Bool = false) {
        guard _canFetchMoreRestaurants else { return }
        
        self.isBusy.value = true
        
        let query = [
            "start": String(_restaurantStartCount),
            "count": String(_numberOfRestaurantsPerCall),
            "lat": _userLocation.lat,
            "lon": _userLocation.long,
            "sort": restaurantFilter.rawValue
        ]
        
        _restaurantWebService.getRestaurants(query: query) { [weak self] (result: Result<RestaurantListObject?, WebServiceError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let restaurantList):
                guard let restaurantList = restaurantList else { return }
                self._addRestaurantsToList(restaurantList, clearList)
            case .failure( let error):
                print("Display error: \(error)")
            }
            
            self.isBusy.value = false
        }
    }
    
    private func _addRestaurantsToList(_ restaurants: RestaurantListObject, _ clearList: Bool) {
        guard restaurants.resultsShown > 0 else {
            _canFetchMoreRestaurants = false
            _displayReasonForNotAddingRestaurants()
            return
        }
        
        _increaseRestaurantStartCount(with: restaurants.resultsShown)
        
        let newRestaurantList = restaurants.restaurants.map { value -> Restaurant in
            let distance = _getRestaurantDistance(value.restaurant.location)
            return Restaurant(value.restaurant, isFavorite: _favoriteRestaurants.contains(value.restaurant.id), distance: distance)
        }
        
        if clearList {
            restaurantList.removeAllAndAdd(object: newRestaurantList)
        } else {
            restaurantList.addAll(newRestaurantList)
        }
        
        if isSearching {
            _searchRestaurant(search: _search)
        }
    }
    
    private func _getRestaurantDistance(_ location: LocationObject) -> String {
        let distance = _locationService.getDistanceFrom(restaurantLocation: (lat: location.latitude, long: location.longitude))
        
        guard let realDistance = distance else { return "" }
        
        return Helper.getDistanceInMetrics(realDistance)
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
        
        if isSearching {
            _searchRestaurant(search: _search)
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
    
    private func _getFavoriteRestaurants() {
        _favoriteRestaurants = _restaurantDatabaseService.getFavorites().map { $0.id }
        _updateRestaurantListWithFavorites()
    }
    
    private func _updateRestaurantListWithFavorites() {
        guard !restaurantList.data.value.isEmpty else { return }
        
        var restaurants = restaurantList.data.value
        
        for index in 0..<restaurants.count {
            let isFavorite = _favoriteRestaurants.contains(restaurants[index].getId())
            restaurants[index].setFavorite(isFavorite)
        }
        
        restaurantList.removeAllAndAdd(object: restaurants)
        
        if isSearching {
            _searchRestaurant(search: _search)
        }
    }
    
    private func _searchRestaurant(search: String) {
        _search = search
        isSearching = true
        
        guard !search.isEmpty else {
            searchRestaurantList.removeAllAndAdd(object: restaurantList.data.value)
            return
        }
        
        let searchRestaurants = restaurantList.data.value.filter {
            $0.containsSearch(search)
        }
        
        searchRestaurantList.removeAllAndAdd(object: searchRestaurants)
    }
    
    private func _cancelSearch() {
        _search = ""
        isSearching = false
        searchRestaurantList.removeAll()
        restaurantList.data.notify()
    }
    
    private func _filterRestaurants(filter: Int) {
        restaurantFilter = RestaurantFilter.allCases[filter]
        _clearRestaurantCount()
        _fetchRestaurants(clearList: true)
    }
    
    private func _canExecute() -> Bool {
        return !self.isBusy.value
    }
}


