//
//  DiContainer.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

enum DiContainer {
    private static var _registrations = [AnyHashable: () -> Any]()
    private static var _viewControllerRegistrations = [AnyHashable: () -> Any]()
    
    static func register<T>(_: T.Type, constructor: @escaping () -> Any) {
        let dependencyName = String(describing: T.self)
        _registrations[dependencyName] = constructor
    }
    
    static func registerSingleton<T>(_: T.Type, constructor: @escaping () -> Any) {
        let dependencyName = String(describing: T.self)
        var instance: Any?
        
        let resolver: () -> Any = {
            if instance == nil {
                instance = constructor()
                return instance!
            } else {
                return instance!
            }
        }
        
        _registrations[dependencyName] = resolver
    }
    
    static func registerViewController<T>(_: T.Type, constructor: @escaping () -> Any) {
        let dependencyName = String(describing: T.self)
        _viewControllerRegistrations[dependencyName] = constructor
    }
    
    static func resolve<T>(type: T.Type = T.self) -> T {
        let dependencyName = String(describing: T.self)
        
        guard let resolver = _registrations[dependencyName] else {
            fatalError("No registration for type \(dependencyName)")
        }
        
        guard let result = resolver() as? T else {
            fatalError("Can't cast registration to type \(dependencyName)")
        }
        
        return result
    }
    
    static func resolveViewController<T>(name: String) -> T {
        guard let resolver = _viewControllerRegistrations[name] else {
            fatalError("No registration for type \(name)")
        }
        
        guard let result = resolver() as? T else {
            fatalError("Can't cast registration to type \(name)")
        }
        
        return result
    }
}
