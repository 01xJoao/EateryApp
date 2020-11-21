//
//  CollectionViewDataSource.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

enum Section { case restaurants }

final class RestaurantsCollectionDataSource: UICollectionViewDiffableDataSource<Section, Restaurant> {
    private let _estimatedCellWidth:CGFloat = 270
    private var _lastScrollPosition:CGFloat = 0
    
    private var _restaurantList = [Restaurant]()
    private let _fetchRestaurantsHandler: Command
    
    init(collectionView: UICollectionView, fetchHandler: Command) {
        collectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: RestaurantCell.reuseId)
        _fetchRestaurantsHandler = fetchHandler

        super.init(collectionView: collectionView) { (collectionView, indexPath, rastaurant) -> UICollectionViewCell? in
            let restaurantCell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.reuseId, for: indexPath) as! RestaurantCell
            restaurantCell.configure(with: rastaurant)
            
            return restaurantCell
        }
    }
    
    func updateData(on restaurants: [Restaurant]) {
        _restaurantList.append(contentsOf: restaurants)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.restaurants])
        snapshot.appendItems(restaurants, toSection: .restaurants)
        self.apply(snapshot, animatingDifferences: true)
    }
}

extension RestaurantsCollectionDataSource: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width

        var cellWidth: CGFloat = 0
        let provisoryItemCountInRow: CGFloat = (collectionViewWidth / _estimatedCellWidth)
        let cellCount = ceil(provisoryItemCountInRow)
        
        if(provisoryItemCountInRow > 2) {
            cellWidth = _calculateCellWidth(provisoryItemCountInRow, cellCount, collectionViewWidth)
        } else {
            cellWidth = collectionViewWidth / 2
        }
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowLayout.minimumInteritemSpacing * cellCount
        let itemWidth: CGFloat = cellWidth - spaceBetweenCells
        let itemHeight: CGFloat = itemWidth * 1.73
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    private func _calculateCellWidth(_ provisoryItemCountInRow: CGFloat, _ cellCount: CGFloat, _ collectionViewWidth: CGFloat) -> CGFloat {
        let cellWidth = ceil(collectionViewWidth / (provisoryItemCountInRow + 1))
        
        let remainder = provisoryItemCountInRow.truncatingRemainder(dividingBy: 1)
        let increaseCellSizePercentage = (remainder / cellCount)
        
        return cellWidth + (cellWidth * increaseCellSizePercentage)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        18
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if _shouldFetchMoreRestaurants(scrollView) {
            _fetchRestaurantsHandler.executeIf()
        }
        
        _lastScrollPosition = scrollView.contentOffset.y
    }
    
    private func _shouldFetchMoreRestaurants(_ scrollView: UIScrollView) -> Bool {
        let scrollPosition = scrollView.contentOffset.y
        let scrollSize = scrollView.contentSize.height
        
        return scrollPosition > _lastScrollPosition && scrollPosition > (scrollSize * 0.6)
    }
}
