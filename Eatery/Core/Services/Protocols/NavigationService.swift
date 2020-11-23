//
//  NavigationService.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

protocol NavigationService {
    func navigate<TViewModel: ViewModel>(viewModel: TViewModel.Type, arguments: Any?, animated: Bool)
    func navigateAndSetAsContainer<TViewModel: ViewModel>(viewModel: TViewModel.Type)
    func close(arguments: Any?, animated: Bool)
}
