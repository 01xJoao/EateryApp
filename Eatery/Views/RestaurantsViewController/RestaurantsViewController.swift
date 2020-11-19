//
//  RestaurantViewController.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

final class RestaurantsViewController: BaseViewController<RestaurantsViewModel>, UISearchResultsUpdating {
    private lazy var _collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var _collectionDataSource = RestaurantsCollectionDataSource(collectionView: _collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Restaurants"
        _setupView()
    }
    
    private func _setupView() {
        _setData()
        _configureFilterButton()
        _configureSearchController()
        _configureCollectionView()
    }
    
    private func _setData() {
        viewModel.restaurantList.data.addObserver(observer: "restaurants") { [weak self] in
            guard let self = self else { return }
            
            self._collectionDataSource.updateData(on: self.viewModel.restaurantList.data.value)
        }
    }
    
    private func _configureFilterButton() {
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .done, target: self, action: #selector(_filterAction))
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc private func _filterAction() {}
    
    private func _configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.searchTextField.backgroundColor = UIColor.Theme.black.withAlphaComponent(0.35)
        
        searchController.searchBar.setImage(UIImage(systemName: "leaf")!.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal),
                                            for: UISearchBar.Icon.search, state: .normal)
        
        searchController.searchBar.setImage(UIImage(systemName: "xmark.circle.fill")!.withTintColor(UIColor.Theme.white, renderingMode: .alwaysOriginal),
                                            for: UISearchBar.Icon.clear, state: .normal)
        
        searchController.searchBar.searchTextField.attributedText =
            NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Theme.white])
    
        searchController.searchBar.searchTextField.attributedPlaceholder =
            NSAttributedString.init(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        self.navigationItem.searchController = searchController
    }
    
    private func _configureCollectionView() {
        _setCollectionViewHorizontalScroll()
        
        self.view.addSubview(_collectionView)
        
        _collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 10, right: 12)
        _collectionView.delegate = _collectionDataSource
        _collectionView.dataSource = _collectionDataSource
        _collectionView.backgroundColor = .clear
        _collectionView.showsHorizontalScrollIndicator = false
        
        _collectionView.anchor(top: self.view.topAnchor, leading: self.view.safeAreaLayoutGuide.leadingAnchor,
                               bottom: self.view.bottomAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor)
    }
    
    private func _setCollectionViewHorizontalScroll() {
        if let flowLayout = _collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {}
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in self._collectionView.collectionViewLayout.invalidateLayout() }
    }
}
