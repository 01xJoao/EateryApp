//
//  MainViewController.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

final class MainViewController: BaseTabBarController<MainViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        _createTabBarController()
    }
    
    private func _createTabBarController() {
        self.viewControllers = [
            _createViewTab(RestaurantsViewModel.self, viewModel.restaurantsTitle,  UIImage(systemName: "leaf")!),
            _createViewTab(FavoritesViewModel.self, viewModel.favoritesTitle, UIImage(systemName: "heart.circle")!)
        ]
        
        _changeTabBarTitleColor()
    }
    
    private func _createViewTab<TViewModel: ViewModel>(_ vm: TViewModel.Type, _ title: String, _ image: UIImage) -> UIViewController{
        let viewController: BaseViewController<TViewModel> = DiContainer.resolveViewController(name: String(describing: vm.self))
        
        viewController.tabBarItem = UITabBarItem(title: title, image: image.withTintColor(UIColor.Theme.darkGrey, renderingMode: .alwaysOriginal),
                                                 selectedImage: image.withTintColor(UIColor.Theme.mainGreen, renderingMode: .alwaysOriginal))
        
        let navigationController = UINavigationController()
        navigationController.pushViewController(viewController, animated: false)
        return navigationController
    }
    
    private func _changeTabBarTitleColor() {
        tabBar.standardAppearance = UITabBarAppearance()
        
        [ tabBar.standardAppearance.stackedLayoutAppearance,
          tabBar.standardAppearance.inlineLayoutAppearance,
          tabBar.standardAppearance.compactInlineLayoutAppearance
        ].forEach { appearence in
            appearence.selected.titleTextAttributes = [.foregroundColor: UIColor.Theme.mainGreen]
        }
    }
}
