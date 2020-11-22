//
//  FavoritesViewController.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

final class FavoritesViewController: BaseViewController<FavoritesViewModel> {
    private let _tableView = UITableView()
    private lazy var _tableDataSourceProvider = FavoritesDataSource(_tableView, unfavoriteHandler: _unfavoriteHandler)
    
    private let _backgroundImage = UIImageView(image: UIImage(systemName: "leaf")?.withTintColor(UIColor.Theme.lightGrey, renderingMode: .alwaysOriginal))
    
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
        viewModel.favoriteList.data.addObserver(observer: "favorites") { [weak self] in
            guard let self = self else { return }
            
            self._updateBackgroundImage()
            self._tableDataSourceProvider.favoriteList = self.viewModel.favoriteList.data.value
        }
    }
    
    private func _configureTableView() {
        self.view.addSubview(_tableView)
        
        _tableView.backgroundColor = .clear
        _tableView.delegate = _tableDataSourceProvider
        _tableView.dataSource = _tableDataSourceProvider
        
        _tableView.anchor(top: self.view.topAnchor, leading: self.view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: self.view.bottomAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor)
        
        _tableView.reloadData()
    }
    
    private func _unfavoriteHandler(restaurantId: String) {
        viewModel.unfavoriteRestaurantCommand.execute(restaurantId)
    }
    
    private func _configureViewBackgroundImage() {
        self.view.addSubview(_backgroundImage)
        
        _backgroundImage.centerInSuperview(size: CGSize(width: 60, height: 55))
    }
    
    private func _updateBackgroundImage() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self._backgroundImage.isHidden = !self.viewModel.favoriteList.data.value.isEmpty
        }
    }
}
