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
    private let _locationService: LocationService
    private let _dialogService: DialogService
    
    private var _restaurantStartCount = 1
    private let _numberOfRestaurantsPerCall = 20
    private var _canFetchMoreRestaurants = true
    private var _userLocation: (lat: String, long: String)?
    private var _favoriteRestaurants = [String]()
    private let _searchRadius = "20000"
    private var _search = ""
    
    private(set) var restaurantList = DynamicValueList<Restaurant>()
    private(set) var searchRestaurantList = DynamicValueList<Restaurant>()
    private(set) var isSearching = false
    private(set) var restaurantFilter = RestaurantFilterType.distance
    
    private(set) lazy var fetchMoreRestaurantsCommand = Command({ self._fetchRestaurants()}, canExecute: _canExecute)
    private(set) lazy var favoriteRestaurantCommand = WpCommand(_favoriteRestaurant)
    private(set) lazy var seachRestaurantCommand = WpCommand(_searchRestaurant)
    private(set) lazy var cancelSearchRestaurantCommand = Command(_cancelSearch)
    private(set) lazy var changeFilterCommand = WpCommand(_filterRestaurants)
    private(set) lazy var navigateToRestaurantCommand = WpCommand(_navigateToRetaurant)
    
    init(restaurantWebService: RestaurantWebService, locationService: LocationService, restaurantDatabaseService: RestaurantDatabaseService, dialogService: DialogService) {
        _restaurantWebService = restaurantWebService
        _restaurantDatabaseService = restaurantDatabaseService
        _locationService = locationService
        _dialogService = dialogService
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
                if !self._locationService.checkUserAuthorization() {
                    self._dialogService.showInfo(I18N.localize(key: "dialog_enableAppLocation"), informationType: .bad)
                }
                return
            }
            
            if(self._userLocation == nil || self._userLocation! != location) {
                self._getRestaurantsIn(location: location)
            }
        }
    }
    
    private func _requestUserLocation() {
        if !_locationService.requestUserAuthorization() {
            self._dialogService.showInfo(I18N.localize(key: "dialog_enableDeviceLocation"), informationType: .bad)
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
    
    private func _fetchRestaurants(clearRestaurantList: Bool = false) {
        self.isBusy.value = true
        
        guard _canFetchMoreRestaurants, let userLocation = _userLocation else {
            self.isBusy.value = false
            return
        }
        
        let query = [
            "start": String(_restaurantStartCount),
            "count": String(_numberOfRestaurantsPerCall),
            "lat": userLocation.lat,
            "lon": userLocation.long,
            "radius": _searchRadius,
            "sort": restaurantFilter.rawValue,
            "order": restaurantFilter.getOrder()
        ]
        
        _restaurantWebService.getRestaurants(query: query) { [weak self] (result: Result<RestaurantListObject?, WebServiceErrorType>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let restaurantList):
                guard let restaurantList = restaurantList else { return }
                self._addRestaurantsToList(restaurantList, clearRestaurantList)
            case .failure(let error):
                self._dialogService.showInfo(I18N.localize(key: error.rawValue), informationType: .bad)
            }
            
            self.isBusy.value = false
        }
    }
    
    private func _addRestaurantsToList(_ restaurants: RestaurantListObject, _ clearRestaurantList: Bool) {
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
        
        if clearRestaurantList {
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
            self._dialogService.showInfo(I18N.localize(key: "dialog_noRestaurantsFound"), informationType: .bad)
        } else {
            self._dialogService.showInfo(I18N.localize(key: "dialog_noMoreRestaurants"), informationType: .info)
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
        _search = search.lowercased()
        isSearching = true
        
        guard !_search.isEmpty else {
            searchRestaurantList.removeAllAndAdd(object: restaurantList.data.value)
            return
        }
        
        let searchRestaurants = restaurantList.data.value.filter {
            $0.containsSearch(_search)
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
        restaurantFilter = RestaurantFilterType.allCases[filter]
        _clearRestaurantCount()
        _fetchRestaurants(clearRestaurantList: true)
    }
    
    private func _navigateToRetaurant(restaurantId: String) {
        let restaurant = restaurantList.data.value.first { $0.getId() == restaurantId }
        navigationService.navigate(viewModel: RestaurantDetailViewModel.self, arguments: restaurant, animated: true)
    }
    
    private func _canExecute() -> Bool {
        return !self.isBusy.value
    }
    
    let titleLabel = I18N.localize(key: "restaurants")
    let searchLabel = I18N.localize(key: "restaurants_search")
    let distanceLabel = I18N.localize(key: "restaurants_distance")
    let ratingLabel = I18N.localize(key: "restaurants_rating")
    let priceLabel = I18N.localize(key: "restaurants_price")
}
