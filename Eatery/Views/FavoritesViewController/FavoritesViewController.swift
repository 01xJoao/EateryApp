//
//  FavoritesViewController.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

final class FavoritesViewController: BaseViewController<FavoritesViewModel> {
    private let _tableView = UITableView()
    private lazy var _dataSourceProvider = FavoritesDataSource(_tableView, [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        
        _setupView()
    }
    
    private func _setupView() {
        _setData()
        _configureTableView()
        _configureViewBackgroundImage()
    }
    
    private func _setData() {
        
    }
    
    private func _configureTableView() {
        self.view.addSubview(_tableView)
        
        _tableView.backgroundColor = .clear
        
        _tableView.anchor(top: self.view.topAnchor, leading: self.view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: self.view.bottomAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor)
    }
    
    private func _configureViewBackgroundImage() {
        
    }
}
