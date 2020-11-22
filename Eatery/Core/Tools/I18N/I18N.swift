//
//  I18N.swift
//  Eatery
//
//  Created by João Palma on 22/11/2020.
//

import Foundation

struct I18N {
    static private var _currentLanguage: String?
    static private let _defaultLanguage: String = "en"
    static private let _supportedLanguages: [String] = ["en", "pt"]
    
    static private var _resources = [LiteralObject]()
    
    static private var resourcesManager: [LiteralObject] {
        if _resources.isEmpty {
            _setLanguage()
            _loadJsonString()
        }
        
        return _resources
    }
    
    static func getCurrentLanguage() -> String {
        if _currentLanguage == nil {
            _setLanguage()
        }
        
        return _currentLanguage!
    }
    
    static func localize(key: String) -> String {
        let value = resourcesManager.first(where: { $0.key == key })
        return value?.translated ?? ""
    }
    
    static private func _setLanguage() {
        guard let preferredLanguage = Locale.preferredLanguages.first else {
            _currentLanguage = _defaultLanguage
            return
        }
        
        guard let language = preferredLanguage.split(separator: "-").first else {
            _currentLanguage = _defaultLanguage
            return
        }
        
        _currentLanguage = _supportedLanguages.first(where: { $0 == language }) ?? _defaultLanguage
    }
    
    static private func _loadJsonString() {
        guard let path = Bundle.main.path(forResource: _currentLanguage, ofType: "json") else {
            print("No json file found.")
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSDictionary
            
            guard let result = jsonResult else { return }
            
            for (key, value) in result {
                _resources.append(LiteralObject(key: key as! String, translated: value as! String))
            }
        } catch let error {
            print(error)
        }
    }
}

struct LiteralObject {
    var key, translated: String
}
