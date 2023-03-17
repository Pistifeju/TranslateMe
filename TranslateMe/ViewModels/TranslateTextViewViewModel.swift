//
//  TranslateTextViewViewModel.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import MLKitTranslate
import JGProgressHUD

final class TranslateTextViewViewModel {
    
    public var languagePair = TMLanguagePair(sourceLanguage: .english, targetLanguage: .hungarian)
    
    public var speechRecognizer = TMSpeechRecognizer()
        
    public func stopSpeechRecognizerListening() {
        if speechRecognizer.isListening {
            speechRecognizer.stopListening()
        }
    }
    
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
