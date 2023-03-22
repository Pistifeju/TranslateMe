//
//  TranslateViewModel.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import JGProgressHUD

class TranslateViewModel {
    public var languagePair = TXLanguagePair(sourceLanguage: .english, targetLanguage: .hungarian)
    
    public func createDownloadLanguageProgressHud() -> JGProgressHUD {
        let progressHud = JGProgressHUD(style: .light)
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                progressHud.style = .dark
            }
        }
        
        progressHud.textLabel.text = "Downloading language..."
        progressHud.animation = JGProgressHUDFadeZoomAnimation()
        return progressHud
    }
}
