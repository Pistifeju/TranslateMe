//
//  TXLanguagePair.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 15..
//

import Foundation
import MLKitTranslate

class TXLanguagePair {
    let locale = Locale.current
    var sourceLanguage: TranslateLanguage
    var targetLanguage: TranslateLanguage
    var sourceText: String
    var targetText: String
    
    var sourceLanguageString: String {
        return locale.localizedString(forLanguageCode: sourceLanguage.rawValue)?.capitalized ?? ""
    }
    
    var targetLanguageString: String {
        return locale.localizedString(forLanguageCode: targetLanguage.rawValue)?.capitalized ?? ""
    }
    
    init(sourceLanguage: TranslateLanguage, targetLanguage: TranslateLanguage, translationText: String = "") {
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.sourceText = translationText
        self.targetText = ""
    }
    
    public func switchLanguages() {
        (sourceLanguage, targetLanguage) = (targetLanguage, sourceLanguage)
        (sourceText, targetText) = (targetText, sourceText)
    }
    
    public func translate(from: TranslateLanguage, to: TranslateLanguage, translateFromTarget: Bool, completion: @escaping () -> Void) {
        let sourceLanguage = translateFromTarget ? to : from
        let targetLanguage = translateFromTarget ? from : to
        
        let options = TranslatorOptions(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
        let translator = Translator.translator(options: options)
        
        let textToTranslate = translateFromTarget ? targetText : sourceText
        
        translator.translate(textToTranslate) { translatedText, error in
            if translateFromTarget {
                if let translatedText = translatedText {
                    self.sourceText = translatedText
                } else {
                    self.sourceText = ""
                }
            } else {
                if let translatedText = translatedText {
                    self.targetText = translatedText
                } else {
                    self.targetText = ""
                }
            }
            
            completion()
        }
    }
}
