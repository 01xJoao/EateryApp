//
//  RestaurantMenuObject.swift
//  Eatery
//
//  Created by João Palma on 23/11/2020.
//

import Foundation

struct ReviewObject: Codable {
    let reviewsCount: Int
    let userReviews: [UserReviewObject]

    enum CodingKeys: String, CodingKey {
        case reviewsCount = "reviews_count"
        case userReviews = "user_reviews"
    }
}

struct UserReviewObject: Codable {
    let review: ReviewElementObject
}

struct ReviewElementObject: Codable {
    let rating: Double
    let reviewText: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case rating, user
        case reviewText = "review_text"
    }
}

struct User: Codable {
    let name: String
}
