//
//  LocationService.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

protocol LocationService where Self: LocationServiceImp {
    func getUserLocation() -> DynamicValue<String?>
    func checkUserAuthorization() -> Bool
    func requestUserAuthorization() -> Bool
}
