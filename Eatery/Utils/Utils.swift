//
//  Utils.swift
//  Eatery
//
//  Created by João Palma on 23/11/2020.
//

import UIKit

enum Utils {
    static let keyWindow: UIWindow = UIApplication.shared.windows.first {$0.isKeyWindow}!
}

enum LocalConstants {
    static let AlertDialogHeight: CGFloat = 50
}
