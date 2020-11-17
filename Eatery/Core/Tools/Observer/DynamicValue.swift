//
//  DynamicValue.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

final class DynamicValue<T> {
    var value : T { didSet { notify() } }
    private var _observers = [String: CompletionHandler]()
    
    init(_ value: T) {
        self.value = value
    }
    
    func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        _observers[observer.description] = completionHandler
    }
    
    func addAndNotify(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        addObserver(observer, completionHandler: completionHandler)
        notify()
    }
    
    func removeObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        _observers.removeValue(forKey: observer.description)
    }
    
    func notify() {
        _observers.forEach({ $0.value() })
    }
    
    deinit {
        _observers.removeAll()
    }
}

final class DynamicValueList<T> : NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
    
    func add(object: T){
        data.value.append(object)
    }
    
    func addAll(object: [T]){
        data.value.append(contentsOf: object)
    }
    
    func remove(at: Int){
        data.value.remove(at: at)
    }
    
    func removeAll(){
        data.value.removeAll()
    }
}
