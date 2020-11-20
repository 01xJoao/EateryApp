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
    //private var _userCity: CityStruct()
    
    private(set) var restaurantList = DynamicValueList<Restaurant>()
    
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
                self._getRestaurants()
            }
        }
    }
    
    private func _requestLocation() {
        if !_locationService.requestUserAuthorization() {
            print("Please enable location services on your phone.")
        }
    }
    
    private func _getRestaurants() {
        self.isBusy.value = true
        
        let query = [
            "start": "1",
            "count": "20",
            "lat": _userLocation.lat,
            "lon": _userLocation.long,
            "sort": "real_distance"
        ]
        
        _restaurantWebService.getRestaurants(query: query) { [weak self] (result: Result<RestaurantListStruct?, WebServiceError>) in
            guard let self = self else { return }
            self.isBusy.value = false
            
            switch result {
            case .success(let restaurantList):
                guard let restaurantList = restaurantList else { return }
                self._fillRestaurantListWith(restaurantList)
            case .failure( let error):
                print("Display error: \(error)")
            }
        }
    }
    
    private func _fillRestaurantListWith(_ restaurants: RestaurantListStruct) {
        guard restaurants.resultsFound > 0 else {
            print("We could not find restaurants in your location :/")
            return
        }
        
        let newRestaurantList = restaurants.restaurants.map { val -> Restaurant in
            Restaurant(val.restaurant)
        }
        
        restaurantList.addAll(newRestaurantList)
    }
}
