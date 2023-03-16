//
//  TMSpeaker.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 15..
//

import Foundation
import AVFoundation
import MLKitTranslate

final class TMSpeaker {
    public static let shared = TMSpeaker()
    
    private init () {}
    
    private let synthesizer = AVSpeechSynthesizer()
    
    public func speak(text: String, language: TranslateLanguage) {
        let utterance = AVSpeechUtterance(string: text)
        let languageCode = createLanguageCode(translateLanguage: language)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        synthesizer.speak(utterance)
    }
    
    private func createLanguageCode(translateLanguage: TranslateLanguage) -> String {
        
        var voice: String {
            switch translateLanguage {
            case .arabic:
                return "ar-SA"
            case .bulgarian:
                return "bg-BG"
            case .catalan:
                return "ca-ES"
            case .czech:
                return "cs-CZ"
            case .chinese:
                return "zh-CN"
            case .croatian:
                return "hr-HR"
            case .dutch:
                return "nl-NL"
            case .danish:
                return "da-DK"
            case .english:
                return "en-GB"
            case .french:
                return "fr-FR"
            case .finnish:
                return "fi-FI"
            case .greek:
                return "el-GR"
            case .german:
                return "de-DE"
            case .hungarian:
                return "hu-HU"
            case .hindi:
                return "hi-IN"
            case .hebrew:
                return "he-IL"
            case .italian:
                return "it-IT"
            case .indonesian:
                return "id-ID"
            case .japanese:
                return "ja-JP"
            case .korean:
                return "ko-KR"
            case .malay:
                return "ms-MY"
            case .norwegian:
                return "no-NO"
            case .polish:
                return "pl-PL"
            case .portuguese:
                return "pt-PT"
            case .russian:
                return "ru-RU"
            case .romanian:
                return "ro-RO"
            case .slovak:
                return "sk-SK"
            case .spanish:
                return "es-ES"
            case .swedish:
                return "sv-SE"
            case .thai:
                return "th-TH"
            case .turkish:
                return "tr-TR"
            case .ukrainian:
                return "uk-UA"
            case .vietnamese:
                return "vi-VN"
            default:
                return "" //This should never run.
            }
        }
        
        return voice
    }
}
