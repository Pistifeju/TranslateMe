//
//  TMLanguagePair.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 15..
//

import Foundation
import MLKitTranslate

struct TMLanguagePair {
    let locale = Locale.current
    var sourceLanguage: TranslateLanguage
    var targetLanguage: TranslateLanguage
    
    var sourceLanguageString: String {
        return locale.localizedString(forLanguageCode: sourceLanguage.rawValue)?.capitalized ?? ""
    }
    var targetLanguageString: String {
        return locale.localizedString(forLanguageCode: targetLanguage.rawValue)?.capitalized ?? ""
    }
    
    public mutating func switchLanguages() {
        (sourceLanguage, targetLanguage) = (targetLanguage, sourceLanguage)
    }
}
