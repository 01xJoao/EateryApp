//
//  WebService.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import Foundation

protocol WebService {
    func getRequest<T: Codable>(path: String, query: [String: String?], completion: @escaping CompletionWebHandler<T>)
}
