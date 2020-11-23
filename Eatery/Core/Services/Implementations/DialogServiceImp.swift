//
//  DialogServiceImp.swift
//  Eatery
//
//  Created by João Palma on 23/11/2020.
//

import Foundation

final class DialogServiceImp: DialogService {
    func showInfo(_ description: String, informationType: InfoDialogType) {
        DispatchQueue.main.async {
            let infoView = InfoDialogView()
            infoView.showInfo(text: description, infoType: informationType)
        }
    }
}
