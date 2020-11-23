//
//  Review.swift
//  Eatery
//
//  Created by João Palma on 23/11/2020.
//

import Foundation

struct Review {
    private let _review: UserReviewObject
    
    init(_ review: UserReviewObject) {
        _review = review
    }
    
    func getRating() -> String {
        "\(String(_review.review.rating))/5"
    }
    
    func getRawRating() -> Double {
        _review.review.rating
    }
    
    func getText() -> String {
        _review.review.reviewText
    }
    
    func getUser() -> String {
        _review.review.user.name
    }
}
