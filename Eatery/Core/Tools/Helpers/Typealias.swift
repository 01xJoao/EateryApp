//
//  Typealias.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

typealias CompletionHandler = () -> Void
typealias CompletionHandlerWithParam<T> = (T) -> Void
typealias CanExecuteCompletionHandler = () -> (Bool)
