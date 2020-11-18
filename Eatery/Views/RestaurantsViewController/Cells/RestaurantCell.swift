//
//  RestaurantCell.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

final class RestaurantCell: UICollectionViewCell {
    static let reuseId = "RestaurantCell"
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.Theme.mainGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
