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

    private var _userLocation = ""
    private var _userCity: CityStruct?
    private var _restaurantList = Set<[Restaurant]>()
    
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
        
        locationNotification.addAndNotify(observer: _userLocation.description) { [weak self] in
            guard let self = self else { return }
            
            guard let location = locationNotification.value else {
                print("Please enable app location services in settings.")
                return
            }
            
            if(self._userLocation != location) {
                self._userLocation = location
                self._getUserCity()
            }
        }
    }
    
    private func _requestLocation() {
        if !_locationService.requestUserAuthorization() {
            print("Please enable location services on your phone.")
        }
    }
    
    
    private func _getUserCity() {
        _restaurantWebService.getCityDetails(query: ["q": _userLocation]) { [weak self] (result: Result<CityListStruct?, WebServiceError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let cityList):
                guard let cityList = cityList else { return }
                self._saveCityDetails(cityList)
            case .failure( let error):
                print("Display error: \(error)")
            }
        }
    }
    
    private func _saveCityDetails(_ cityList: CityListStruct) {
        if let city = cityList.locationSuggestions.first {
            _userCity = city
            _getRestaurants()
        } else {
            print("We could not find your location :(")
        }
    }
    
    private func _getRestaurants() {
        guard let _userCity = _userCity else { return }
        
        let query = ["entity_id": String(_userCity.id), "entity_type": "city", "start": "1", "count": "20"]
        
        _restaurantWebService.getRestaurants(query: query) { [weak self] (result: Result<RestaurantListStruct?, WebServiceError>) in
            guard let self = self else { return }
            
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
        
        _restaurantList.insert(newRestaurantList)
    }
}
