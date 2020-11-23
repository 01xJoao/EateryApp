//
//  Enums.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import UIKit

enum WebServiceErrorType: String, Error {
    case noInternet = "error_noInternet"
    case requestError = "error_webRequest"
    case dataError = "error_webData"
}

enum ImageFilterType: String {
    case chrome = "CIPhotoEffectChrome"
    case fade = "CIPhotoEffectFade"
    case noir = "CIPhotoEffectNoir"
    case process = "CIPhotoEffectProcess"
    case transfer =  "CIPhotoEffectTransfer"
}

enum RestaurantFilterType: String, CaseIterable {
    case distance = "real_distance"
    case rating = "rating"
    case cost = "cost"
    
    func getOrder() -> String {
        switch self {
        case RestaurantFilterType.distance: return "asc"
        case RestaurantFilterType.rating: return "desc"
        case RestaurantFilterType.cost: return "asc"
        }
    }
    
    static let allValues = [distance, rating, cost]
}

enum InfoDialogType {
    case good
    case bad
    case info
}

extension InfoDialogType: RawRepresentable {
    typealias RawValue = UIColor

    init?(rawValue: RawValue) {
        switch rawValue {
        case UIColor.Theme.green: self = .good
        case UIColor.Theme.red: self = .bad
        case UIColor.Theme.yellow: self = .info
        default: return nil
        }
    }

    var rawValue: RawValue {
        switch self {
        case .good: return UIColor.Theme.green
        case .bad: return UIColor.Theme.red
        case .info: return UIColor.Theme.yellow
        }
    }
}
