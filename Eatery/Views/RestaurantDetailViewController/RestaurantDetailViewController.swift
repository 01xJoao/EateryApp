//
//  RestaurantDetailViewController.swift
//  Eatery
//
//  Created by João Palma on 23/11/2020.
//

import UIKit

class RestaurantDetailViewController: BaseViewController<RestaurantDetailViewModel> {
    override var largeTitle: Bool { false }
    
    private let _tableView = UITableView()
    
    private let _restaurantImageView = UIImageView(backgroundColor: UIColor.Theme.backgroundColor)
    private let _navigationBackgroundView = UIView(backgroundColor: UIColor.Theme.mainGreen)
    private let _menuBackgroundView = UIView(backgroundColor: UIColor.Theme.backgroundColor)
    private let _menuLabel = UILabel(text: "Menu", font: .systemFont(ofSize: 24, weight: .bold), textColor: .label, textAlignment: .left, numberOfLines: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.restaurant.getName()
        _setupView()
    }
    
    private func _setupView() {
        _configureCustomNavigationBar()
        _configureMenuView()
        _configureRestaurantImage()
        _configureTableView()
    }
    
    private func _configureCustomNavigationBar() {
        self.view.addSubview(_navigationBackgroundView)
        _navigationBackgroundView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor)
        _navigationBackgroundView.withHeight(80)
    }
    
    private func _configureMenuView() {
        self.view.addSubview(_menuBackgroundView)
        
        _menuBackgroundView.anchor(top: _navigationBackgroundView.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor)
        _menuBackgroundView.withHeight(100)
        
        _menuBackgroundView.addSubview(_menuLabel)
        _menuLabel.anchor(top: nil, leading: _menuBackgroundView.leadingAnchor, bottom: _menuBackgroundView.bottomAnchor, trailing: _menuBackgroundView.trailingAnchor,
                                   padding: .init(top: 0, left: 20, bottom: 20, right: 0))
    }
    
    private func _configureRestaurantImage() {
        let backgroundShadow = UIView(backgroundColor: UIColor.Theme.backgroundColor)
        self.view.addSubview(backgroundShadow)
        
        backgroundShadow.centerXTo(_navigationBackgroundView.centerXAnchor)
        backgroundShadow.centerYTo(_navigationBackgroundView.bottomAnchor)
        backgroundShadow.withSize(.init(width: 140, height: 140))
        
        backgroundShadow.layer.cornerRadius = 70
        backgroundShadow.layer.shadowOpacity = 0.35
        backgroundShadow.layer.shadowRadius = 3
        backgroundShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundShadow.layer.borderWidth = 4
        backgroundShadow.layer.borderColor = UIColor.Theme.white.cgColor
        backgroundShadow.addSubview(_restaurantImageView)
        
        _restaurantImageView.fillSuperview()
        _restaurantImageView.layer.cornerRadius = 70
        _restaurantImageView.layer.masksToBounds = true
        _restaurantImageView.contentMode = .center
        
        let defaultImage = UIImage(systemName: "photo.on.rectangle.angled")!.withTintColor(UIColor.Theme.darkGrey, renderingMode: .alwaysOriginal)
                    .resizedImage(for: .init(width: 50, height: 40))
        
        _restaurantImageView.image = defaultImage
        
        _setRestaurantImage(viewModel.restaurant.getThumbnail())
    }
    
    private func _setRestaurantImage(_ imageUrl: String) {
        guard !imageUrl.isEmpty else { return }
        
        ImageCache.shared.getImage(from: imageUrl, completed: { [weak self] (image, cachedKey) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self._restaurantImageView.contentMode = .scaleAspectFill
                self._restaurantImageView.image = image
            }
        })
    }
    
    private func _configureTableView() {
        self.view.addSubview(_tableView)
        _tableView.anchor(top: _menuBackgroundView.bottomAnchor, leading: self.view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: self.view.bottomAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor)
    }
}
