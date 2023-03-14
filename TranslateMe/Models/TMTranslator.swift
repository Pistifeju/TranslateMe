//
//  TMTranslator.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import MLKitTranslate

final class TMTranslator {
    
    public static let shared = TMTranslator()
    
    private init () {}
    
    private let locale = Locale.current
    
    var allTranslateLanguages: [TranslateLanguage] {
        TranslateLanguage.allLanguages().sorted {
            return locale.localizedString(forLanguageCode: $0.rawValue)!
            < locale.localizedString(forLanguageCode: $1.rawValue)!
        }
    }
    
    var allLanguages: [String] {
        return allTranslateLanguages.compactMap {
            locale.localizedString(forLanguageCode: $0.rawValue)?.capitalized
        }
    }
    
    public func createLanguageString(language: TranslateLanguage) -> String {
        guard let language = locale.localizedString(forLanguageCode: language.rawValue)?.capitalized else {
            return ""
        }
        return language
    }
}
