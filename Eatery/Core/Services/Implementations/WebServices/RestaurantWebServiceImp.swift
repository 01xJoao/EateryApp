//
//  RestaurantWebService.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import Foundation

final class RestaurantWebServiceImp: RestaurantWebService {
    private let _webService: WebService
    
    init(webService: WebService) {
        self._webService = webService
    }
    
    func getCityDetails(query: [String : String?], completion: @escaping CompletionWebHandler<CityListStruct>) {
        _webService.getRequest(path: "/cities", query: query, completion: completion)
    }
    
    func getRestaurants(query: [String : String?], completion: @escaping CompletionWebHandler<RestaurantListStruct>) {
        _webService.getRequest(path: "/search", query: query, completion: completion)
    }
}
