//
//  ViewModelBase.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

class ViewModelBase: ViewModel {
    private(set) var navigationService: NavigationService = DiContainer.resolve()
    let isBusy : DynamicValue<Bool> = DynamicValue<Bool>(false)
    
    func prepare(arguments: Any) {}
    func initialize() {}
    func appearing() {}
    func disappearing() {}
    func backAction() {}
}
