//
//  TranslateTextViewViewModel.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import MLKitTranslate

final class TranslateTextViewViewModel {
    
    public var leftSelectedLanguage = TranslateLanguage.english
    public var rightSelectedLanguage = TranslateLanguage.hungarian
     
    public var leftSelectedLanguageString = Locale.current.localizedString(forLanguageCode: "en")!.capitalized
    public var rightSelectedLanguageString = Locale.current.localizedString(forLanguageCode: "hu")!.capitalized
    
    public private(set) var languages = TMTranslator.shared.allLanguages
    public private(set) var translateLanguages = TMTranslator.shared.allTranslateLanguages
    
    public private(set) var localModels = ModelManager.modelManager().downloadedTranslateModels
    
    public func switchLanguages() {
        (leftSelectedLanguageString, rightSelectedLanguageString) = (rightSelectedLanguageString, leftSelectedLanguageString)
        (leftSelectedLanguage, rightSelectedLanguage) = (rightSelectedLanguage, leftSelectedLanguage)
    }
}
