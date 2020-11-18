//
//  LocationServiceImp.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import CoreLocation

final class LocationServiceImp: NSObject, LocationService, CLLocationManagerDelegate {
    private var _locationManager: CLLocationManager = CLLocationManager()
    private var _currentLocation = ""
    
    override init() {
        super.init()
        
        if(checkUserAuthorization()) {
            _setupLocationManager()
        }
    }
    
    func _setupLocationManager() {
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.distanceFilter = kCLDistanceFilterNone
        _locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let currentlocation = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        _fetchCityAndCountry(from: currentlocation) { [weak self] city, country, error in
            guard let self = self else { return }
            self._currentLocation = city ?? country ?? ""
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.authorizedWhenInUse) {
            _setupLocationManager()
        }
    }
    
    func _fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality, placemarks?.first?.country, error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error location manager")
    }
    
    func getUserLocation() -> String {
        _currentLocation
    }
    
    func checkUserAuthorization() -> Bool {
        CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse
    }
    
    func requestUserAuthorization() {
        if(!CLLocationManager.locationServicesEnabled()) {
            self._locationManager.requestWhenInUseAuthorization()
        }
    }
}
