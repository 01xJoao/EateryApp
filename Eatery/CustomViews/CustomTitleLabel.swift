//
//  GFTitleLabel.swift
//  GHFollowers
//
//  Created by João Palma on 07/10/2020.
//

import UIKit

class CustomTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        _configure()
    }
    
    convenience init(textAligment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAligment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    
    private func _configure() {
        self.textColor = .label
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.8
        self.lineBreakMode = .byTruncatingTail
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
