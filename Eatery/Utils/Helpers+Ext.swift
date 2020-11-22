//
//  Helpers+Ext.swift
//  Eatery
//
//  Created by João Palma on 22/11/2020.
//

import UIKit

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct UIHelper {
    static func getColorForPrice(_ price: String) -> UIColor {
        switch price {
        case "$":  return UIColor.Theme.mainGreen
        case "$$": return UIColor.Theme.orange
        default: return  UIColor.Theme.red
        }
    }
}
