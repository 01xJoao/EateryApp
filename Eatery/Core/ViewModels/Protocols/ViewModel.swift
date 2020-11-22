//
//  ViewModel.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

protocol ViewModel {
    func prepare(arguments: Any)
    func initialize()
    func appearing()
    func disappearing()
}
