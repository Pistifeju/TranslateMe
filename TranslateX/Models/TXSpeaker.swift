//
//  TXSpeaker.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 15..
//

import Foundation
import AVFoundation
import MLKitTranslate

final class TXSpeaker {
    static let shared = TXSpeaker()
    
    private init () {}
    
    private let synthesizer = AVSpeechSynthesizer()
    
    public func speak(text: String, language: TranslateLanguage) {
        let utterance = AVSpeechUtterance(string: text)
        let languageCode = language.createLanguageCode()
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        synthesizer.speak(utterance)
    }
}
