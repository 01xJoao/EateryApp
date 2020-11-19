//
//  RestaurantWebService.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import Foundation

protocol RestaurantWebService where Self: RestaurantWebServiceImp {
    func getCityDetails(query: [String: String?], completion: @escaping CompletionWebHandler<CityListStruct>)
    func getRestaurants(query: [String: String?], completion: @escaping CompletionWebHandler<RestaurantListStruct>)
}
