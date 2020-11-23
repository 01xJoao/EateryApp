//
//  BaseViewController.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

class BaseViewController<TViewModel: ViewModel>: UIViewController {
    private(set) var viewModel: TViewModel!
    var arguments: Any?
    var largeTitle: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setViewConfigurations()
        _instantiateViewModel()
    }
    
    private func _setViewConfigurations() {
        self.view.backgroundColor = UIColor.Theme.backgroundColor
        self.navigationController?.navigationBar.prefersLargeTitles = largeTitle
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func _instantiateViewModel() {
        let viModel: TViewModel = DiContainer.resolve()
        
        if let args = arguments {
            viModel.prepare(arguments: args)
        }
        
        viewModel = viModel
        viewModel.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.appearing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.disappearing()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
