//
//  FavoriteCell.swift
//  Eatery
//
//  Created by João Palma on 20/11/2020.
//

import UIKit

final class FavoriteCell: UITableViewCell {
    static let reuseId = "FavoriteCell"
    
    private let _backgroundView = UIView(backgroundColor: UIColor.Theme.backgroundColor)
    
    private let _restaurantImageView = UIImageView(backgroundColor: UIColor.Theme.lightGrey)
    private let _defaultRestaurantImage = UIImageView(image: UIImage(systemName: "photo.on.rectangle.angled")?.withTintColor(UIColor.Theme.darkGrey, renderingMode: .alwaysOriginal))
    
    private let _heartButton = UIButton()
    private let _heartImage = UIImageView(image: UIImage(systemName: "heart.slash.fill" )?.withTintColor(UIColor.Theme.red, renderingMode: .alwaysOriginal))
    
    private let _titleLabel = CustomTitleLabel(textAligment: .left, fontSize: 18)
    private let _subtitleLabel = CustomBodyLabel(textAligment: .left, fontSize: 15, color: UIColor.Theme.darkGrey)
    private let _priceRangeLabel = CustomBodyLabel(textAligment: .right, fontSize: 17, color: UIColor.Theme.mainGreen, weight: .semibold)
    
    private let _distanceLabel = CustomBodyLabel(textAligment: .left, fontSize: 14, color: .darkGray)
    private let _distanceImage = UIImageView(image: UIImage(systemName: "figure.walk")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal))
    
    private let _timeLabel = CustomBodyLabel(textAligment: .left, fontSize: 14, color: .darkGray)
    private let _timeImage = UIImageView(image: UIImage(systemName: "clock")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal))
    
    private var _restaurantImageWidthConstraint:NSLayoutConstraint!
    
    private var _restaurantId = ""
    private var _favoriteHandler: CompletionHandlerWithParam<String>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setupCell()
    }
    
    public func configure(with favorite: Favorite, favoriteHandler: @escaping CompletionHandlerWithParam<String>) {
        _favoriteHandler = favoriteHandler
        _restaurantId = favorite.getId()
            
        _priceRangeLabel.text = favorite.getPriceRange()
        _priceRangeLabel.textColor = UIHelper.getColorForPrice(favorite.getPriceRange())
        
        _titleLabel.text = favorite.getName()
        _subtitleLabel.text =  favorite.getCuisines()
        _timeLabel.text = favorite.getTiming()
        _distanceLabel.text = favorite.getDistance()
        
        if let image = favorite.getImage() {
            _restaurantImageView.image = UIImage(data: image)
            _defaultRestaurantImage.isHidden = true
        } else {
            _restaurantImageView.image = nil
            _defaultRestaurantImage.isHidden = false
        }
    }
    
    private func _setupCell() {
        _configureBackgroundView()
        _configureRestaurantImageView()
        _configurePriceLabel()
        _configureTitleAndSubtitle()
        _configureFavoriteButton()
        _configureInfoView(_timeLabel, _timeImage, 3)
        _configureInfoView(_distanceLabel, _distanceImage, 26)
    }
    
    private func _configureBackgroundView() {
        self.contentView.addSubview(_backgroundView)
        _backgroundView.fillSuperview(padding: .init(top: 12, left: 12, bottom: 4, right: 12))
        
        _backgroundView.layer.cornerRadius = 8
        _backgroundView.layer.shadowOpacity = 0.35
        _backgroundView.layer.shadowRadius = 3
        _backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    private func _configureRestaurantImageView() {
        _backgroundView.addSubview(_restaurantImageView)
        _restaurantImageView.anchor(top: _backgroundView.topAnchor, leading: _backgroundView.leadingAnchor,
                                    bottom: _backgroundView.bottomAnchor, trailing: nil,
                                    padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        
        _restaurantImageView.layer.cornerRadius = 10
        _restaurantImageView.layer.masksToBounds = true
        
        _restaurantImageWidthConstraint = _restaurantImageView.widthAnchor.constraint(equalToConstant: 0)
        _restaurantImageWidthConstraint.isActive = true
        
        _restaurantImageView.addSubview(_defaultRestaurantImage)
        _defaultRestaurantImage.centerInSuperview(size: CGSize(width: 50, height: 40))
    }
    
    private func _configurePriceLabel() {
        _backgroundView.addSubview(_priceRangeLabel)
        _priceRangeLabel.anchor(top: _backgroundView.topAnchor, leading: nil, bottom: nil, trailing: _backgroundView.trailingAnchor,
                                padding: .init(top: 5, left: 15, bottom: 0, right: 12))
    }
    
    private func _configureTitleAndSubtitle() {
        _backgroundView.addSubview(_titleLabel)
        _titleLabel.anchor(top: _restaurantImageView.topAnchor, leading: _restaurantImageView.trailingAnchor, bottom: nil, trailing: nil,
                           padding: .init(top: 0, left: 12, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            _titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: _priceRangeLabel.leadingAnchor)
        ])
        
        self.contentView.addSubview(_subtitleLabel)
        _subtitleLabel.anchor(top: _titleLabel.bottomAnchor, leading: _titleLabel.leadingAnchor, bottom: nil, trailing: _backgroundView.trailingAnchor,
                              padding: .init(top: 4, left: 0, bottom: 0, right: 12))
        
        _titleLabel.numberOfLines = 2
    }
    
    private func _configureFavoriteButton() {
        _backgroundView.addSubview(_heartButton)
        
        _heartButton.anchor(top: nil, leading: nil, bottom: _backgroundView.bottomAnchor, trailing: _backgroundView.trailingAnchor,
                            padding: .init(top: 0, left: 0, bottom: 5, right: 3))
        
        _heartButton.withSize(CGSize(width: 47, height: 47))
        
        _heartButton.addSubview(_heartImage)
        _heartImage.fillSuperview(padding: .init(top: 13, left: 11, bottom: 9, right: 7))
        
        _heartButton.addTarget(self, action: #selector(_heartButtonTouched), for: .touchUpInside)
    }
    
    @objc private func _heartButtonTouched() {
        guard let favoriteHandler = _favoriteHandler else { return }
        
        favoriteHandler(_restaurantId)
    }
    
    private func _configureInfoView(_ textLabel: UILabel, _ imageLabel: UIImageView, _ paddingBottom: CGFloat) {
        _backgroundView.addSubview(textLabel)
        imageLabel.withSize(CGSize(width: 14.5, height: 16))
        
        let stackView = UIView().hstack(
            imageLabel,
            textLabel,
            spacing: 6
        )
        
        self.contentView.addSubview(stackView)
        stackView.anchor(top: nil, leading: _titleLabel.leadingAnchor, bottom: _restaurantImageView.bottomAnchor, trailing: _heartButton.leadingAnchor,
                            padding: .init(top: 0, left: 0, bottom: paddingBottom, right: 2))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        _restaurantImageWidthConstraint.constant = _restaurantImageView.bounds.height * 0.8
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
