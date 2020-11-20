//
//  WebServiceImp.swift
//  Eatery
//
//  Created by João Palma on 18/11/2020.
//

import Foundation

final class WebServiceImp: WebService {
    private let _zomatoAPIKey = "38fd20391c95ec7757bb9b1010596d17"
    private let _URLSession: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(20)
        configuration.timeoutIntervalForResource = TimeInterval(20)
        _URLSession = URLSession(configuration: configuration)
    }

    func getRequest<T>(path: String, query: [String: String?], completion: @escaping CompletionWebHandler<T>) where T : Decodable, T : Encodable {
        let requestComponent = _createURLComponent(path, query)
        
        guard let composedURL = requestComponent.url else {
            print("URL creation failed...")
            return
        }
 
        var getRequest = URLRequest(url: composedURL)
        getRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        getRequest.setValue(_zomatoAPIKey, forHTTPHeaderField: "user-key")

        _URLSession.dataTask(with: getRequest) { data, response, error in
            if let _ = error {
                completion(.failure(WebServiceError.noInternet))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("API status: \(httpResponse.statusCode)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else  {
                completion(.failure(WebServiceError.requestError))
                return
            }
            
            guard let validData = data else {
                completion(.failure(WebServiceError.dataError))
                return
            }
            
            do {
                let value = try JSONDecoder().decode(T.self, from: validData)
                completion(.success(value))
            } catch {
                completion(.failure(WebServiceError.dataError))
            }
            
        }.resume()
    }
    
    private func _createURLComponent(_ path: String, _ query: [String: String?]) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "developers.zomato.com"
        components.path = "/api/v2.1\(path)"
        components.queryItems = query.map { URLQueryItem(name: $0, value: $1) }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: ",", with: "%2C")
        
        return components
    }
}
