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
        let itemHeight: CGFloat = 200
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    private func _calculateCellWidth(_ provisoryItemCountInRow: CGFloat, _ cellCount: CGFloat, _ collectionViewWidth: CGFloat) -> CGFloat {
        let cellWidth = ceil(collectionViewWidth / (provisoryItemCountInRow + 1))
        
        let remainder = provisoryItemCountInRow.truncatingRemainder(dividingBy: 1)
        let increaseCellSize = (remainder / cellCount)
        
        return cellWidth + (cellWidth * increaseCellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}
