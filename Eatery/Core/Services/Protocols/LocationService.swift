//
//  LocationService.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

protocol LocationService where Self: LocationServiceImp {
    func getUserLocation() -> String
    func checkUserAuthorization() -> Bool
    func requestUserAuthorization()
}
