//
//  Command.swift
//  Eatery
//
//  Created by João Palma on 21/11/2020.
//

import Foundation

struct Command {
    private var action: CompletionHandler
    private let canExecuteAction: CanExecuteCompletionHandler
    
    init(_ action: @escaping CompletionHandler, canExecute: @escaping CanExecuteCompletionHandler = { true }) {
        self.action = action
        self.canExecuteAction = canExecute
    }
    
    func execute() {
        action()
    }
    
    func executeIf() {
        if canExecuteAction() {
            action()
        }
    }
    
    func canExecute() -> Bool {
        return canExecuteAction()
    }
}
