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
        _configureFilterButton()
        _configureSearchController()
        _configureCollectionView()
        
        _collectionDataSource.updateData(on: [Restaurant(name: "Fish"), Restaurant(name: "Let"), Restaurant(name: "Done"), Restaurant(name: "Stuff")])
        
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
        
        searchController.searchBar.setImage(UIImage(systemName: "leaf")!.withTintColor(UIColor.Theme.lightGrey, renderingMode: .alwaysOriginal),
                                            for: UISearchBar.Icon.search, state: .normal)
        
        searchController.searchBar.setImage(UIImage(systemName: "xmark.circle.fill")!.withTintColor(UIColor.Theme.white, renderingMode: .alwaysOriginal),
                                            for: UISearchBar.Icon.clear, state: .normal)
        
        searchController.searchBar.searchTextField.attributedText =
            NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Theme.white])
    
        searchController.searchBar.searchTextField.attributedPlaceholder =
            NSAttributedString.init(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Theme.lightGrey])
        
        self.navigationItem.searchController = searchController
    }
    
    private func _configureCollectionView() {
        self.view.addSubview(_collectionView)
        
        _collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 10, right: 12)
        _collectionView.delegate = _collectionDataSource
        _collectionView.dataSource = _collectionDataSource
        _collectionView.backgroundColor = .clear
        
        _collectionView.anchor(top: self.view.topAnchor, leading: self.view.safeAreaLayoutGuide.leadingAnchor,
                               bottom: self.view.bottomAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor)
        
        _setCollectionViewHorizontalScroll()
    }
    
    private func _setCollectionViewHorizontalScroll() {
        if let flowLayout = _collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
}
