//
//  TMLanguages.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import MLKitTranslate

final class TMLanguages {
    
    public static let shared = TMLanguages()
    
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
