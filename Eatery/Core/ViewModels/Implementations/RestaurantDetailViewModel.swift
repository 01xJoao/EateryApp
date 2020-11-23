//
//  RestaurantDetailViewModel.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

final class RestaurantDetailViewModel: ViewModelBase {
    private(set) var restaurant: Restaurant!
    
    override func prepare(arguments: Any) {
        guard let restaurant = arguments as? Restaurant else {
            _navigateBack()
            return
        }
        
        self.restaurant = restaurant
    }
    
    override func initialize() {
        _getRestaurantMenu()
    }
    
    private func _getRestaurantMenu() {
        
    }
    
    
    private func _navigateBack() {
        navigationService.close(arguments: nil, animated: true)
    }
}
