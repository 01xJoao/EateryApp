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

enum FilterType : String {
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Transfer =  "CIPhotoEffectTransfer"
}
