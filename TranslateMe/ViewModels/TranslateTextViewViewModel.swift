//
//  TranslateTextViewViewModel.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import MLKitTranslate
import JGProgressHUD

final class TranslateTextViewViewModel: TranslateViewModel {
    
    public var speechRecognizer = TMSpeechRecognizer()
        
    public let speechNotificationName = "translateTextTranscription"
    
    public func stopSpeechRecognizerListening() {
        if speechRecognizer.isListening {
            speechRecognizer.stopListening()
        }
    }
}
