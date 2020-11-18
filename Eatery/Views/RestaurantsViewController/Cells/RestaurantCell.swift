//
//  RestaurantCell.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

final class RestaurantCell: UICollectionViewCell {
    static let reuseId = "RestaurantCell"
    
    private let _imageView = UIImageView()
    private let _titleLabel = CustomTitleLabel(textAligment: .left, fontSize: 18)
    private let _distanceLabel = CustomBodyLabel(textAligment: .right, fontSize: 12, color: UIColor.Theme.mainGreen)
    private let _distanceImage = UIImageView(image: UIImage(systemName: "figure.walk")!.withTintColor(UIColor.Theme.mainGreen, renderingMode: .alwaysOriginal))
    private let _descriptionLabel = CustomBodyLabel(textAligment: .left, fontSize: 14, color: .secondaryLabel)
    
    private let _starButton = UIButton(backgroundColor: .clear)
    private let _priceScaleLabel = CustomBodyLabel(textAligment: .left, fontSize: 17, color: UIColor.Theme.orange, weight: .semibold)
    private let _ratingLabel = CustomBodyLabel(textAligment: .center, fontSize: 16, color: UIColor.Theme.white, weight: .semibold)
    
    private var _imageHeightConstraint: NSLayoutConstraint?
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        _setupView()
        
        _imageView.backgroundColor = UIColor.Theme.lightGrey
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
        guard let imageHeightConstraint = _imageHeightConstraint else { return }
        
        let newSize = self.bounds.height * 0.77
        
        if(imageHeightConstraint.constant != newSize) {
            imageHeightConstraint.constant = newSize
        }
    }
    
    private func _setupView() {
        _configureImageView()
        _configureTitleLabel()
        _configureDistanceView()
        _configureDescriptionLabel()
        _configureStarButton()
        _configurePriceScaleLabel()
        _configureRatingView()
    }
    
    private func _configureImageView() {
        self.contentView.addSubview(_imageView)
        _imageView.anchor(top: self.contentView.topAnchor, leading: self.contentView.leadingAnchor, bottom: nil, trailing: self.contentView.trailingAnchor)
        _imageView.layer.cornerRadius = 10
        _imageView.layer.shadowOpacity = 0.45
        _imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        _imageHeightConstraint = _imageView.heightAnchor.constraint(equalToConstant: 0)
        _imageHeightConstraint?.isActive = true
    }
    
    private func _configureTitleLabel() {
        self.contentView.addSubview(_titleLabel)
        
        _titleLabel.anchor(top: _imageView.bottomAnchor, leading: _imageView.leadingAnchor, bottom: nil, trailing: _imageView.trailingAnchor,
                           padding: .init(top: 14.5, left: 0, bottom: 0, right: 0))
        
        _titleLabel.text = "Pizzaria Braga"
    }
    
    private func _configureDistanceView() {
        _distanceLabel.text = "3 km"
        
        _distanceImage.withSize(CGSize(width: 12, height: 12))
        
        let distanceView = UIView()
        
        distanceView.hstack(
            _distanceLabel,
            _distanceImage,
            spacing: 3
        )
        
        self.contentView.addSubview(distanceView)
        
        distanceView.anchor(top: _imageView.bottomAnchor, leading: _imageView.leadingAnchor, bottom: nil, trailing: _imageView.trailingAnchor,
                            padding: .init(top: 4, left: 0, bottom: 0, right: 0))
    }
    
    private func _configureDescriptionLabel() {
        self.contentView.addSubview(_descriptionLabel)
        _descriptionLabel.anchor(top: _titleLabel.bottomAnchor, leading: _imageView.leadingAnchor, bottom: nil, trailing: _imageView.trailingAnchor,
                                 padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        _descriptionLabel.text = "Chinese · Sushi"
    }
    
    private func _configureStarButton() {
        self.contentView.addSubview(_starButton)
        
        _starButton.anchor(top: nil, leading: nil, bottom: _imageView.bottomAnchor, trailing: _imageView.trailingAnchor)
        _starButton.withSize(CGSize(width: 47, height: 47))
        
        let starImage = UIImageView(image: UIImage(systemName: "heart.fill")!.withTintColor(UIColor.Theme.red, renderingMode: .alwaysOriginal))
        
        _starButton.addSubview(starImage)
        
        starImage.fillSuperview(padding: .init(top: 10, left: 8, bottom: 10, right: 8))
        starImage.layer.shadowOpacity = 0.4
        starImage.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    private func _configurePriceScaleLabel() {
        self.contentView.addSubview(_priceScaleLabel)
        
        _priceScaleLabel.anchor(top: _imageView.topAnchor, leading: _imageView.leadingAnchor, bottom: nil, trailing: nil,
                                 padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        
        _priceScaleLabel.text = "$$"
        _priceScaleLabel.layer.shadowOpacity = 0.4
        _priceScaleLabel.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        _priceScaleLabel.layer.shadowRadius = 0.5
    }
    
    private func _configureRatingView() {
        let backgroundView = UIView(backgroundColor: UIColor.Theme.mainGreen.withAlphaComponent(0.7))
        
        self.contentView.addSubview(backgroundView)
        
        backgroundView.anchor(top: _imageView.topAnchor, leading: nil, bottom: nil, trailing: _imageView.trailingAnchor,
                                 padding: .init(top: 8, left: 0, bottom: 0, right: 8))
        
        backgroundView.withSize(CGSize(width: 40, height: 26))
        backgroundView.layer.cornerRadius = 8
        backgroundView.addSubview(_ratingLabel)
        
        _ratingLabel.centerInSuperview()
        _ratingLabel.layer.shadowOpacity = 0.4
        _ratingLabel.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        _ratingLabel.layer.shadowRadius = 0.5
        
        _ratingLabel.text = "4.2"
    }
    
    public func configureCell(with restaurant: Restaurant) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
