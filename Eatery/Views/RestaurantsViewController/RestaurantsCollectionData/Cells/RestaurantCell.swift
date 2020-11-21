//
//  RestaurantCell.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

final class RestaurantCell: UICollectionViewCell {
    static let reuseId = "RestaurantCell"
    
    private let _restaurantImageView = UIImageView()
    private let _defaultRestaurantImage = UIImageView(image: UIImage(systemName: "photo.on.rectangle.angled")?.withTintColor(UIColor.Theme.darkGrey, renderingMode: .alwaysOriginal))
   
    private let _titleLabel = CustomTitleLabel(textAligment: .left, fontSize: 18)
    private let _distanceLabel = CustomBodyLabel(textAligment: .right, fontSize: 12, color: UIColor.Theme.mainGreen)
    private let _distanceImage = UIImageView(image: UIImage(systemName: "figure.walk")?.withTintColor(UIColor.Theme.mainGreen, renderingMode: .alwaysOriginal))
    private let _descriptionLabel = CustomBodyLabel(textAligment: .left, fontSize: 14, color: .secondaryLabel)
    
    private let _heartButton = UIButton()
    private let _heartImage = UIImageView()
    private let _priceScaleLabel = CustomBodyLabel(textAligment: .left, fontSize: 17, color: UIColor.Theme.mainGreen, weight: .semibold)
    private let _ratingLabel = CustomBodyLabel(textAligment: .center, fontSize: 16, color: UIColor.Theme.white, weight: .semibold)
    private let _ratingBackgroundView =  UIView(backgroundColor: UIColor.Theme.mainGreen.withAlphaComponent(0.9))
    
    private var _imageHeightConstraint:NSLayoutConstraint?
    private var _imageCacheKey:NSString = ""
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        _setupCell()
    }
    
    public func configure(with restaurant: Restaurant) {
        _titleLabel.text = restaurant.getName()
        _descriptionLabel.text = restaurant.getCuisines()
        _distanceLabel.text = restaurant.getDistance()
        _heartImage.image = _setFavoriteImage(restaurant.isFavorite())
        _setRestaurantImage(nil, false)
        
        _setRestaurantImage(restaurant.getImageWithSize(width: 600, height: 800))
        _setPriceValue(restaurant.getPriceScale())
        _setRatingValue(restaurant.getRating())
    }
    
    private func _setPriceValue(_ price: String) {
        _priceScaleLabel.text = price

        switch price {
        case "$": _priceScaleLabel.textColor = UIColor.Theme.mainGreen; return
        case "$$": _priceScaleLabel.textColor = UIColor.Theme.orange; return
        default: _priceScaleLabel.textColor = UIColor.Theme.red; return
        }
    }
    
    private func _setRatingValue(_ rating: String?) {
        guard let rating = rating else {
            _ratingLabel.text = ""
            _ratingBackgroundView.isHidden = true
            return
        }
        
        _ratingBackgroundView.isHidden = false
        _ratingLabel.text = rating
    }
    
    private func _setupCell() {
        _configureImageView()
        _configureTitleLabel()
        _configureDistanceView()
        _configureDescriptionLabel()
        _configureFavoriteButton()
        _configurePriceScaleLabel()
        _configureRatingView()
    }
    
    private func _configureImageView() {
        let backgroundShadow = UIView(backgroundColor: UIColor.Theme.backgroundColor)
        self.contentView.addSubview(backgroundShadow)
        
        backgroundShadow.anchor(top: self.contentView.topAnchor, leading: self.contentView.leadingAnchor, bottom: nil, trailing: self.contentView.trailingAnchor)
        backgroundShadow.layer.cornerRadius = 10
        backgroundShadow.layer.shadowOpacity = 0.35
        backgroundShadow.layer.shadowRadius = 3
        backgroundShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        backgroundShadow.addSubview(_restaurantImageView)
        _restaurantImageView.fillSuperview()
        
        _restaurantImageView.layer.cornerRadius = backgroundShadow.layer.cornerRadius
        _restaurantImageView.layer.masksToBounds = true
        _restaurantImageView.contentMode = .scaleAspectFill
        
        _imageHeightConstraint = _restaurantImageView.heightAnchor.constraint(equalToConstant: 0)
        _imageHeightConstraint?.isActive = true
        
        _restaurantImageView.addSubview(_defaultRestaurantImage)
        _defaultRestaurantImage.centerInSuperview(size: CGSize(width: 50, height: 40))
    }
    
    private func _configureTitleLabel() {
        self.contentView.addSubview(_titleLabel)
        
        _titleLabel.anchor(top: _restaurantImageView.bottomAnchor, leading: _restaurantImageView.leadingAnchor, bottom: nil, trailing: _restaurantImageView.trailingAnchor,
                           padding: .init(top: 18, left: 0, bottom: 0, right: 0))
    }
    
    private func _configureDistanceView() {
        _distanceImage.withSize(CGSize(width: 12, height: 12))
        
        let distanceView = UIView()
        
        distanceView.hstack(
            _distanceLabel,
            _distanceImage,
            spacing: 3
        )
        
        self.contentView.addSubview(distanceView)
        
        distanceView.anchor(top: _restaurantImageView.bottomAnchor, leading: _restaurantImageView.leadingAnchor, bottom: nil, trailing: _restaurantImageView.trailingAnchor,
                            padding: .init(top: 4, left: 0, bottom: 0, right: 0))
    }
    
    private func _configureDescriptionLabel() {
        self.contentView.addSubview(_descriptionLabel)
        _descriptionLabel.anchor(top: _titleLabel.bottomAnchor, leading: _restaurantImageView.leadingAnchor, bottom: nil, trailing: _restaurantImageView.trailingAnchor,
                                 padding: .init(top: 2.5, left: 0, bottom: 0, right: 0))
    }
    
    private func _configureFavoriteButton() {
        self.contentView.addSubview(_heartButton)
        
        _heartButton.anchor(top: nil, leading: nil, bottom: _restaurantImageView.bottomAnchor, trailing: _restaurantImageView.trailingAnchor)
        _heartButton.withSize(CGSize(width: 47, height: 47))
        _heartButton.addSubview(_heartImage)

        _heartImage.fillSuperview(padding: .init(top: 10, left: 8, bottom: 10, right: 8))
        _heartImage.layer.shadowOpacity = 0.4
        _heartImage.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    private func _configurePriceScaleLabel() {
        self.contentView.addSubview(_priceScaleLabel)
        
        _priceScaleLabel.anchor(top: _restaurantImageView.topAnchor, leading: _restaurantImageView.leadingAnchor, bottom: nil, trailing: nil,
                                 padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        
        _priceScaleLabel.layer.shadowOpacity = 0.4
        _priceScaleLabel.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        _priceScaleLabel.layer.shadowRadius = 0.5
    }
    
    private func _configureRatingView() {
        self.contentView.addSubview(_ratingBackgroundView)
        
        _ratingBackgroundView.anchor(top: _restaurantImageView.topAnchor, leading: nil, bottom: nil, trailing: _restaurantImageView.trailingAnchor,
                                 padding: .init(top: 8, left: 0, bottom: 0, right: 8))
        
        _ratingBackgroundView.withSize(CGSize(width: 40, height: 26))
        _ratingBackgroundView.layer.cornerRadius = 8
        _ratingBackgroundView.addSubview(_ratingLabel)
        
        _ratingLabel.centerInSuperview()
        _ratingLabel.layer.shadowOpacity = 0.4
        _ratingLabel.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        _ratingLabel.layer.shadowRadius = 0.5
    }
    
    private func _setFavoriteImage(_ isFavorite: Bool) -> UIImage? {
        UIImage(systemName: isFavorite ? "heart.fill" : "heart" )?.withTintColor(UIColor.Theme.red, renderingMode: .alwaysOriginal)
    }
    
    private func _setRestaurantImage(_ imageUrl: String) {
        _imageCacheKey = NSString(string: imageUrl)
        
        guard !imageUrl.isEmpty else { return }
        
        ImageCache.shared.getImage(from: imageUrl, completed: { [weak self] (image, cachedKey) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                guard let image = image, let cachedKey = cachedKey else {
                    self._setRestaurantImage(nil, false)
                    return
                }
                
                if self._imageCacheKey == cachedKey {
                    self._setRestaurantImage(image, true)
                } else {
                    self._setRestaurantImage(nil, false)
                }
            }
        })
    }
    
    private func _setRestaurantImage(_ image: UIImage?, _ isHidden: Bool) {
        self._restaurantImageView.image = image
        self._defaultRestaurantImage.isHidden = isHidden
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
        guard let imageHeightConstraint = _imageHeightConstraint else { return }
        
        let newSize = self.bounds.height * 0.77
        
        if(imageHeightConstraint.constant != newSize) {
            imageHeightConstraint.constant = newSize
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
