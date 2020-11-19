//
//  Restaurant.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

struct Restaurant: Hashable {
    private let _restaurant: RestaurantStruct
    //private let _bigSizeImage: Bool
    private var _isFavorite = false

    init(_ restaurant: RestaurantStruct) {
        _restaurant = restaurant
        //_bigSizeImage = Bool.random()
    }
    
    func getName() -> String {
        _restaurant.name
    }
    
    func getRating() -> String? {
        let rating = _restaurant.userRating.aggregateRating
        
        switch rating {
        case .integer:
            return nil
        case .string(let val):
            return val
        }
    }
    
    func getPriceScale() -> String {
        switch _restaurant.priceRange {
        case 0, 1: return "$"
        case 2: return "$$"
        default: return "$$$"
        }
    }
    
//    func isImageBig() -> Bool {
//        _bigSizeImage
//    }
    
    func getDistance() -> String {
        return "3 km"
    }
    
    func getImageWithSize(width: Int, height: Int) -> String {
        let image = _restaurant.thumb.replacingOccurrences(of: "=200%", with: "=\(String(width))%")
                                     .replacingOccurrences(of: "200%", with: "\(String(height))%")
                                     .replacingOccurrences(of: "C200%", with: "C\(String(width))%")
                                     .replacingOccurrences(of: "200&", with: "\(String(height))&")
        
        return image
    }
    
    func getCuisines() -> String {
        _restaurant.cuisines.replacingOccurrences(of: ",", with: " ·")
    }
    
    func isFavorite() -> Bool {
        _isFavorite
    }
    
    mutating func setFavorite(_ favorite: Bool) {
        _isFavorite = favorite
    }
}
