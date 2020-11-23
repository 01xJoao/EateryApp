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
    
    func getRestaurants(query: [String: String?], completion: @escaping CompletionWebHandler<RestaurantListObject>) {
        _webService.getRequest(path: "/search", query: query, completion: completion)
    }
    
    func getRestaurantReviews(query: [String: String?], completion: @escaping CompletionWebHandler<ReviewObject>) {
        _webService.getRequest(path: "/reviews", query: query, completion: completion)
    }
}
