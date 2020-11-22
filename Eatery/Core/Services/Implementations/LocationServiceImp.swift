//
//  LocationServiceImp.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import CoreLocation

final class LocationServiceImp: NSObject, LocationService, CLLocationManagerDelegate {    
    private var _locationManager: CLLocationManager = CLLocationManager()
    private let _currentLocation : DynamicValue<(String, String)?> = DynamicValue<(String, String)?>((lat: "", long: ""))
    private var _location: CLLocation?
    
    override init() {
        super.init()
        
        _locationManager.delegate = self
        
        if(checkUserAuthorization()) {
            _setupLocationManager()
        }
    }
    
    private func _setupLocationManager() {
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.distanceFilter = kCLDistanceFilterNone
        _locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        _location = location
        
        _currentLocation.value = (lat: String(location.coordinate.latitude), long: String(location.coordinate.longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.authorizedWhenInUse) {
            _setupLocationManager()
        } else if (status == CLAuthorizationStatus.denied) {
            _currentLocation.value = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error location manager")
    }
    
    func getUserLocation() -> DynamicValue<(String, String)?> {
        _currentLocation
    }
    
    func checkUserAuthorization() -> Bool {
        CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse
    }
    
    func requestUserAuthorization() -> Bool {
        if(CLLocationManager.locationServicesEnabled()) {
            self._locationManager.requestWhenInUseAuthorization()
            return true
        }
        
        return false
    }
    
    func getDistanceFrom(restaurantLocation: (lat: String, long: String)) -> Int? {
        guard let location = _location, !restaurantLocation.lat.isEmpty, !restaurantLocation.long.isEmpty else { return nil }
        
        let distance = location.distance(from: CLLocation(latitude: CLLocationDegrees(Double(restaurantLocation.lat)!),
                                                          longitude:  CLLocationDegrees(Double(restaurantLocation.long)!)))
        
        return Int(distance)
    }
}
