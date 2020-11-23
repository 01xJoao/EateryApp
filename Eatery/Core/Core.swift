//
//  Core.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import Foundation

struct Core {
    static func initialize() {
        _registerServices()
        _registerViewModels()
        _registerViewControllers()
        _startApp()
    }
    
    private static func _registerServices() {
        DiContainer.registerSingleton(NavigationService.self, constructor: { NavigationServiceImp() })
        DiContainer.registerSingleton(LocationService.self, constructor: { LocationServiceImp() })
        DiContainer.registerSingleton(WebService.self, constructor: { WebServiceImp() })
        DiContainer.registerSingleton(RestaurantWebService.self, constructor: { RestaurantWebServiceImp(webService: DiContainer.resolve()) })
        DiContainer.registerSingleton(RestaurantDatabaseService.self, constructor: { RestaurantDatabaseServiceImp() })
        DiContainer.registerSingleton(DialogService.self, constructor: { DialogServiceImp() })
    }
    
    private static func _registerViewModels() {
        DiContainer.register(MainViewModel.self, constructor: { MainViewModel() })
        DiContainer.register(FavoritesViewModel.self, constructor: { FavoritesViewModel(restaurantDatabaseService: DiContainer.resolve(), locationSerivce: DiContainer.resolve()) })
        DiContainer.register(RestaurantsViewModel.self, constructor: { RestaurantsViewModel(restaurantWebService: DiContainer.resolve(), locationService: DiContainer.resolve(),
                                                                                            restaurantDatabaseService: DiContainer.resolve(), dialogService: DiContainer.resolve()) })
    }
    
    private static func _registerViewControllers() {
        DiContainer.registerViewController(MainViewModel.self, constructor: { MainViewController() })
        DiContainer.registerViewController(RestaurantsViewModel.self, constructor: { RestaurantsViewController() })
        DiContainer.registerViewController(FavoritesViewModel.self, constructor: { FavoritesViewController() })
    }
    
    private static func _startApp() {
        let navigationService: NavigationService = DiContainer.resolve()
        navigationService.navigateAndSetAsContainer(viewModel: MainViewModel.self)
    }
}
