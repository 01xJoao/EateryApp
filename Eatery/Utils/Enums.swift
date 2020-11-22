//
//  Enums.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import Foundation

enum WebServiceError: String, Error {
    case noInternet = "No internet connection, please try again later."
    case requestError = "Something went wrong, try again."
    case dataError = "Data received from the server is invalid. Please try again."
}

enum ImageFilterType: String {
    case chrome = "CIPhotoEffectChrome"
    case fade = "CIPhotoEffectFade"
    case noir = "CIPhotoEffectNoir"
    case process = "CIPhotoEffectProcess"
    case transfer =  "CIPhotoEffectTransfer"
}

enum RestaurantFilter: String, CaseIterable {
    case distance = "real_distance"
    case rating = "rating"
    case cost = "cost"
    
    static let allValues = [distance, rating, cost]
}
