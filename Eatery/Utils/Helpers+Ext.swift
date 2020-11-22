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

extension CaseIterable where Self: Equatable {
    var index: Self.AllCases.Index {
        return Self.allCases.firstIndex { self == $0 }!
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

struct Helper {
    static func getDistanceInMetrics(_ distance: Int) -> String {
        if(distance < 1000) {
            return "\(distance) m"
        } else {
            return "\(distance/1000) km"
        }
    }
}
