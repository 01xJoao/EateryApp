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
    
    func addObserver(observer: String, completionHandler: @escaping CompletionHandler) {
        _observers[observer] = completionHandler
    }
    
    func addAndNotify(observer: String, completionHandler: @escaping CompletionHandler) {
        addObserver(observer: observer, completionHandler: completionHandler)
        notify()
    }
    
    func removeObserver(observer: String, completionHandler: @escaping CompletionHandler) {
        _observers.removeValue(forKey: observer.description)
    }
    
    func notify() {
        _observers.forEach({ $0.value() })
    }
    
    deinit {
        _observers.removeAll()
    }
}

final class DynamicValueList<T> {
    private(set) var data: DynamicValue<[T]> = DynamicValue([])
    
    func add(_ object: T){
        data.value.append(object)
    }
    
    func addAll(_ object: [T]){
        data.value.append(contentsOf: object)
    }
    
    func remove(at: Int){
        data.value.remove(at: at)
    }
    
    func removeAll(){
        data.value.removeAll()
    }
}
