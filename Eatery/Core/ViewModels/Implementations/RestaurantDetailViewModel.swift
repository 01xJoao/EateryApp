//
//  RestaurantDetailViewModel.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

final class RestaurantDetailViewModel: ViewModelBase {
    private let _restaurantWebService: RestaurantWebService
    private let _dialogService: DialogService
    
    private(set) var restaurant: Restaurant!
    
    private(set) var reviewList = DynamicValueList<Review>()
    
    init(restaurantWebService: RestaurantWebService, dialogService: DialogService) {
        _restaurantWebService = restaurantWebService
        _dialogService = dialogService
    }
    
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
        self.isBusy.value = true
        
        let query = [
            "user_key": API.zomato,
            "res_id": restaurant.getId()
        ]
        
        _restaurantWebService.getRestaurantReviews(query: query) { [weak self] (result: Result<ReviewObject?, WebServiceErrorType>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let reviews):
                guard let reviews = reviews else { return }
                self._fillRestaurantReviewList(with: reviews)
            case .failure(let error):
                self._dialogService.showInfo(I18N.localize(key: error.rawValue), informationType: .bad)
            }
            
            self.isBusy.value = false
        }
    }
    
    private func _fillRestaurantReviewList(with reviews: ReviewObject) {
        let list = reviews.userReviews.map { Review($0) }
        reviewList.addAll(list)
    }
    
    private func _navigateBack() {
        navigationService.close(arguments: nil, animated: true)
    }
    
    let reviewsLabel = I18N.localize(key: "restaurantDetail_reviews")
    let noReviewsLabel = I18N.localize(key: "restaurantDetail_noReviews")
}
