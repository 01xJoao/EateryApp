//
//  Restaurants.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

final class RestaurantsViewModel: ViewModelBase {
    private let _restaurantWebService: RestaurantWebService
    private var _locationService: LocationService

    private var _userLocation = (lat: "", long: "")
    private(set) var restaurantList = DynamicValueList<Restaurant>()
    
    private var _restaurantStartCount = 1
    private let _numberOfRestaurantsPerCall = 20
    
    private(set) lazy var fetchMoreRestaurantsCommand = Command(_fetchRestaurants, canExecute: _canExecute)
    
    init(restaurantWebService: RestaurantWebService, locationService: LocationService) {
        _restaurantWebService = restaurantWebService
        _locationService = locationService
    }
    
    override func initialize() {
        _getUserLocation()
    }
    
    private func _getUserLocation() {
        if !_locationService.checkUserAuthorization() {
           _requestLocation()
        }
        
        let locationNotification = _locationService.getUserLocation()
        
        locationNotification.addAndNotify(observer: "location") { [weak self] in
            guard let self = self else { return }
            
            guard let location = locationNotification.value else {
                print("Please enable app location services in settings.")
                return
            }
            
            if(self._userLocation != location) {
                self._userLocation = location
                self._fetchRestaurants()
            }
        }
    }
    
    private func _requestLocation() {
        if !_locationService.requestUserAuthorization() {
            print("Please enable location services on your phone.")
        }
    }
    
    private func _fetchRestaurants() {
        self.isBusy.value = true
        
        let query = [
            "start": String(_restaurantStartCount),
            "count": String(_numberOfRestaurantsPerCall),
            "lat": _userLocation.lat,
            "lon": _userLocation.long,
            "sort": "real_distance"
        ]
        
        _restaurantWebService.getRestaurants(query: query) { [weak self] (result: Result<RestaurantListStruct?, WebServiceError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let restaurantList):
                guard let restaurantList = restaurantList else { return }
                self._fillRestaurantListWith(restaurantList)
            case .failure( let error):
                print("Display error: \(error)")
            }
            
            self.isBusy.value = false
        }
    }
    
    private func _fillRestaurantListWith(_ restaurants: RestaurantListStruct) {
        guard restaurants.resultsShown > 0 else {
            print("We could not find restaurants in your location :/") // print("We could not find more restaurants :/")
            return
        }
        
        _addRestaurantStartCount(with: restaurants.resultsShown)
        
        let newRestaurantList = restaurants.restaurants.map { val -> Restaurant in
            Restaurant(val.restaurant)
        }
        
        restaurantList.addAll(newRestaurantList)
    }
    
    private func _addRestaurantStartCount(with restaurantCount: Int) {
        _restaurantStartCount += restaurantCount
        
        print(_restaurantStartCount)
    }
    
    private func _canExecute() -> Bool {
        return !self.isBusy.value
    }
}
