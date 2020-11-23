//
//  RestaurantTableDataSource.swift
//  Eatery
//
//  Created by João Palma on 23/11/2020.
//

import UIKit

final class RestaurantDetailTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let _tableView: UITableView
   
    var reviews = [Review]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?._tableView.reloadData()
            }
        }
    }
    
    init(_ tableView: UITableView) {
        _tableView = tableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let ratingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 42, height: 15))
        let review = reviews[indexPath.row]
        
        cell.textLabel?.text = review.getText()
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.textAlignment = .justified
        cell.textLabel?.font = .systemFont(ofSize: 14)
        
        cell.detailTextLabel?.text = review.getUser()
        cell.detailTextLabel?.textColor = .secondaryLabel
        
        cell.selectionStyle = .none
        cell.accessoryView = ratingLabel
        
        ratingLabel.textAlignment = .right
        ratingLabel.text = review.getRating()
        ratingLabel.textColor = UIHelper.getColorForRating(review.getRawRating())
        ratingLabel.font = .boldSystemFont(ofSize: 14)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews.count
    }
}
