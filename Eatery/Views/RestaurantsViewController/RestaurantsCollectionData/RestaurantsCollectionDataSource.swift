//
//  CollectionViewDataSource.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

final class RestaurantsCollectionDataSource: UICollectionViewDiffableDataSource<Section, Restaurant> {
    static private let _portraitCellMinimumWidth = 300
    
    private let _collectionView: UICollectionView!
    private var _restaurantList = [Restaurant]()
    
    init(collectionView: UICollectionView) {
        _collectionView = collectionView
        _collectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: RestaurantCell.reuseId)

        super.init(collectionView: collectionView) { (collectionView, indexPath, rastaurant) -> UICollectionViewCell? in
            let restaurantCell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.reuseId, for: indexPath) as! RestaurantCell
            return restaurantCell
        }
    }
    
    func updateData(on restaurants: [Restaurant]) {
        _restaurantList.append(contentsOf: restaurants)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.main])
        snapshot.appendItems(restaurants, toSection: .main)
        self.apply(snapshot, animatingDifferences: true)
    }
}

extension RestaurantsCollectionDataSource: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth: CGFloat = min(collectionView.bounds.width, collectionView.bounds.height)
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowLayout.minimumInteritemSpacing * 2
        
        let itemHeight: CGFloat = 200
        let itemWidth: CGFloat = (collectionViewWidth / 2) - spaceBetweenCells
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}


enum Section {
    case main
}
