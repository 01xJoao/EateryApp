//
//  LocationServiceImp.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import CoreLocation

final class LocationServiceImp: NSObject, LocationService, CLLocationManagerDelegate {
    private var _locationManager: CLLocationManager = CLLocationManager()
    private let _currentLocation : DynamicValue<String?> = DynamicValue<String?>("")
    
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
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let currentlocation = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        _fetchCityAndCountry(from: currentlocation) { [weak self] city, country, error in
            guard let self = self, let city = city, let country = country else { return }
            
            self._currentLocation.value = "\(city), \(country)"
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.authorizedWhenInUse) {
            _setupLocationManager()
        } else if (status == CLAuthorizationStatus.denied) {
            _currentLocation.value = nil
        }
    }
    
    private func _fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality, placemarks?.first?.country, error)
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error location manager")
    }
    
    func getUserLocation() -> DynamicValue<String?> {
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
}
