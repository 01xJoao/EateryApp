//
//  LocationService.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

protocol LocationService {
    func getUserLocation() -> DynamicValue<(String, String)?>
    func checkUserAuthorization() -> Bool
    func requestUserAuthorization() -> Bool
    func getDistanceFrom(restaurantLocation: (lat: String, long: String)) -> Int?
}
