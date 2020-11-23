//
//  NavigationServiceImp.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

final class NavigationServiceImp: NavigationService {
    private let rootViewController = { (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).rootViewController }()
    
    func navigate<TViewModel: ViewModel>(viewModel: TViewModel.Type, arguments: Any?, animated: Bool) {
        let viewController: UIViewController = _getViewController(type: viewModel, args: arguments)
        rootViewController.navigationController?.pushViewController(viewController, animated: animated)
    }

    func navigateAndSetAsContainer<TViewModel: ViewModel>(viewModel: TViewModel.Type) {
        let viewController: UIViewController = _getViewController(type: viewModel)
        _setNewContainerViewController(UINavigationController(rootViewController: viewController))
    }

    private func _getViewController<TViewModel: ViewModel>(type: TViewModel.Type, args: Any? = nil) -> UIViewController {
        let viewModelName = String(describing: TViewModel.self)
        let viewController: UIViewController = DiContainer.resolveViewController(name: viewModelName)

        if let arguments = args, let viController = viewController as? BaseViewController<TViewModel> {
            viController.arguments = arguments
        }

        return viewController
    }

    private func _setNewContainerViewController(_ viewController: UIViewController) {
        rootViewController.changeViewController(viewController)
    }

    func close(arguments: Any?, animated: Bool) {
        rootViewController.navigationController?.popViewController(animated: true)
    }
}
