//
//  FavoritesTableDataSource.swift
//  Eatery
//
//  Created by João Palma on 20/11/2020.
//

import UIKit

final class FavoritesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let _favoriteList = [Favorite]()
    
    init(_ tableView: UITableView, _ favorites: [Favorite]) {
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
        cell.configure(with: _favoriteList[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
}
