//
//  InfoDialogView.swift
//  Eatery
//
//  Created by João Palma on 23/11/2020.
//

import UIKit

final class InfoDialogView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.tag = 0
    }

    func showInfo(text: String, infoType: InfoDialogType) {
        _configureView(text, infoType)
        _show()
    }

    private func _configureView(_ text: String, _ infoType: InfoDialogType) {
        self.backgroundColor = infoType.rawValue
        let textLabel: UILabel = UILabel(text: text, font: .boldSystemFont(ofSize: 14), textColor: .label, textAlignment: .center, numberOfLines: 2)

        stack(textLabel, alignment: .center).padBottom(12).padLeft(8).padRight(8).anchor(
            top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor
        )
    }

    private func _show() {
        let dialogHeight: CGFloat = Utils.keyWindow.safeAreaInsets.top + LocalConstants.AlertDialogHeight

        self.frame = CGRect.init(x: 0, y: 0, width: Utils.keyWindow.bounds.width, height: dialogHeight)
        Utils.keyWindow.addSubview(self)

        Animations.slideVerticaly(self, showAnimation: true, completion: { [weak self] _ in
            self?._hide()
        })
    }

    private func _hide() {
        Animations.slideVerticaly(self, showAnimation: false, delay: 3.5, completion: { [weak self] _ in
            self?._removeView()
        })
    }

    private func _removeView() {
        self.viewWithTag(0)?.removeFromSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
