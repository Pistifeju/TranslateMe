//
//  TranslateTextViewViewModel.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import MLKitTranslate
import JGProgressHUD

final class TranslateTextViewViewModel: TranslateViewModel {
    
    public var speechRecognizer = TXSpeechRecognizer()
        
    public let speechNotificationName = "translateTextTranscription"
    
    public func stopSpeechRecognizerListening() {
        if speechRecognizer.isListening {
            speechRecognizer.stopListening()
        }
    }
}
