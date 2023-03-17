//
//  TranslateTextViewViewModel.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import MLKitTranslate

final class TranslateTextViewViewModel {
    
    public var languagePair = TMLanguagePair(sourceLanguage: .english, targetLanguage: .hungarian)
    
    public var speechRecognizer = TMSpeechRecognizer()
        
    public func stopSpeechRecognizerListening() {
        if speechRecognizer.isListening {
            speechRecognizer.stopListening()
        }
    }
}
