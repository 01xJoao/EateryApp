//
//  BaseTabBarViewController.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

class BaseTabBarController<TViewModel: ViewModel>: UITabBarController {
    private(set) var viewModel: TViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        _instantiateViewModel()
    }
    
    private func _instantiateViewModel() {
        let vm : TViewModel = DiContainer.resolve()
        viewModel = vm
        viewModel.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
