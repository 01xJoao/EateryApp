//
//  ImageCache.swift
//  Eatery
//
//  Created by João Palma on 19/11/2020.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let _cache = NSCache<NSString, UIImage>()
    
    func getImage(from urlString: String, completed: @escaping (UIImage?, NSString?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = _getImageWith(key: cacheKey) {
            completed(image, cacheKey)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil, nil)
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let self = self,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil, nil)
                return
            }

            self._saveImageWith(key: cacheKey, image: image)
            
            completed(image, cacheKey)
        }).resume()
    }
    
    
    private func _getImageWith(key: NSString) -> UIImage? {
        return _cache.object(forKey: key)
    }
    
    private func _saveImageWith(key: NSString, image: UIImage) {
        _cache.setObject(image, forKey: key)
    }
}
