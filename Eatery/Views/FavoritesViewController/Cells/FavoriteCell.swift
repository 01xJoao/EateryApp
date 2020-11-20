//
//  FavoriteCell.swift
//  Eatery
//
//  Created by João Palma on 20/11/2020.
//

import UIKit

class FavoriteCell: UITableViewCell {
    static let reuseId = "FavoriteCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setupCell()
    }
    
    public func configure(with favorite: Favorite) {
        
    }
    
    private func _setupCell() {
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
