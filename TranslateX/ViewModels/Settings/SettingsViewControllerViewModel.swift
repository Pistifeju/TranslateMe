//
//  SettingsViewControllerViewModel.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 17..
//

import Foundation
import StoreKit
import UIKit

struct SettingsViewControllerViewModel {    
    let cellViewModels: [SettingsCellViewModel]
    
    public var email = TXSupportEmail(toAdress: "support@supportTranslateX.com", subject: "Support Email", messageHeader: "Please describe your issue below")
    
    public func rateApp(viewController: UIViewController) {
        if let windowScene = viewController.view.window?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
