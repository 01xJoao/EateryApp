//
//  Helpers+Ext.swift
//  Eatery
//
//  Created by João Palma on 22/11/2020.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
