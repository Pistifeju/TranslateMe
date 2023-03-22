//
//  TMLanguages.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import MLKitTranslate

final class TMLanguages {
    
    static let shared = TMLanguages()
    
    private init () {}
    
    private let locale = Locale.current
        
    var allTranslateLanguages: [TranslateLanguage] {
        return [
            .arabic,
            .bulgarian,
            .catalan,
            .czech,
            .chinese,
            .croatian,
            .dutch,
            .danish,
            .english,
            .french,
            .finnish,
            .greek,
            .german,
            .hungarian,
            .hindi,
            .hebrew,
            .italian,
            .indonesian,
            .japanese,
            .korean,
            .malay,
            .norwegian,
            .polish,
            .portuguese,
            .russian,
            .romanian,
            .slovak,
            .spanish,
            .swedish,
            .thai,
            .turkish,
            .ukrainian,
            .vietnamese
        ]
    }
    
    var allLanguagesCode: [String] {
        return allTranslateLanguages.map {
            $0.rawValue
        }
    }
    
    var allLanguages: [String] {
        return allTranslateLanguages.compactMap {
            locale.localizedString(forLanguageCode: $0.rawValue)?.capitalized
        }
    }
    
    public func createTranslateLanguageWithLanguageCode(from languageCode: String) -> TranslateLanguage? {
        if let index = allTranslateLanguages.firstIndex(where: { $0.rawValue == languageCode }) {
            return allTranslateLanguages[index]
        } else {
            return nil
        }
    }
    
    public func createLanguageStringWithTranslateLanguage(from language: TranslateLanguage) -> String {
        guard let language = locale.localizedString(forLanguageCode: language.rawValue)?.capitalized else {
            return ""
        }
        return language
    }
    
    public func createLanguageStringWithLanguageCode(from languageCode: String) -> String {
        guard let language = locale.localizedString(forLanguageCode: languageCode)?.capitalized else {
            return ""
        }
        return language
    }
}
