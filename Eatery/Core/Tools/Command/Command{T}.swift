//
//  Command{T}.swift
//  Eatery
//
//  Created by João Palma on 21/11/2020.
//

import Foundation

struct WpCommand<T> {
    private let actionWithParam: CompletionHandlerWithParam<T>
    private let canExecuteAction: CanExecuteCompletionHandler
    
    init(_ actionWithParam: @escaping CompletionHandlerWithParam<T>, canExecute: @escaping CanExecuteCompletionHandler = { true }) {
        self.actionWithParam = actionWithParam
        self.canExecuteAction = canExecute
    }
    
    func execute(_ value: T) {
        actionWithParam(value)
    }
    
    func executeIf(_ value: T) {
        if canExecuteAction() {
            actionWithParam(value)
        }
    }
    
    func canExecute() -> Bool {
        return canExecuteAction()
    }
}
