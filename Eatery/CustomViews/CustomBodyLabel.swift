//
//  GFBodyLabel.swift
//  GHFollowers
//
//  Created by João Palma on 07/10/2020.
//

import UIKit

class CustomBodyLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        _configure()
    }
    
    convenience init(textAligment: NSTextAlignment, fontSize: CGFloat, color: UIColor, weight: UIFont.Weight = .regular) {
        self.init(frame: .zero)
        self.textAlignment = textAligment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        self.textColor = color
    }
    
    private func _configure() {
        self.font = .preferredFont(forTextStyle: .body)
        self.adjustsFontForContentSizeCategory = true
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.8
        self.lineBreakMode = .byWordWrapping
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
