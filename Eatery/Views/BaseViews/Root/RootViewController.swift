//
//  RootViewController.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

final class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func changeViewController(_ viewController: UIViewController) {
        guard _checkIfCurrentViewControllerIsNotEqualsToNew(viewController) else { return }
        
        _removeCurrentViewController()
        _changeContainerViewController(viewController)
    }
    
    private func _checkIfCurrentViewControllerIsNotEqualsToNew(_ viewController: UIViewController) -> Bool {
        guard !self.children.isEmpty else { return true }
        
        return self.children.first.self != viewController.self
    }
    
    private func _removeCurrentViewController() {
        if !self.children.isEmpty {
            self.willMove(toParent: nil)
            self.children.first!.removeFromParent()
            self.children.first!.view.removeFromSuperview()
        }
    }
    
    private func _changeContainerViewController (_ newViewController: UIViewController) {
        newViewController.view.frame = self.view.bounds
        self.view.addSubview(newViewController.view)
        self.addChild(newViewController)
        newViewController.didMove(toParent: self)
    }
}
