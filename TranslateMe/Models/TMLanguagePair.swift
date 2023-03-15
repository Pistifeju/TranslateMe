//
//  TMLanguagePair.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 15..
//

import Foundation
import MLKitTranslate

class TMLanguagePair {
    let locale = Locale.current
    var sourceLanguage: TranslateLanguage
    var targetLanguage: TranslateLanguage
    var translationText: String
    var translatedText: String
    
    var sourceLanguageString: String {
        return locale.localizedString(forLanguageCode: sourceLanguage.rawValue)?.capitalized ?? ""
    }
    var targetLanguageString: String {
        return locale.localizedString(forLanguageCode: targetLanguage.rawValue)?.capitalized ?? ""
    }
    
    init(sourceLanguage: TranslateLanguage, targetLanguage: TranslateLanguage, translationText: String = "") {
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.translationText = translationText
        self.translatedText = ""
    }
    
    public func switchLanguages() {
        (sourceLanguage, targetLanguage) = (targetLanguage, sourceLanguage)
    }
    
    public func translate(completion: @escaping () -> Void) {
        let options = TranslatorOptions(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
        let translator = Translator.translator(options: options)
        translator.translate(translationText) { translatedText, error in
            guard error == nil, let translatedText = translatedText else {
                self.translatedText = ""
                completion()
                return
            }
            self.translatedText = translatedText
            completion()
            return
        }
    }
}
