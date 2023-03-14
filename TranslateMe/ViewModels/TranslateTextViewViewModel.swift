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
     
    public var leftSelectedLanguageString = "English"
    public var rightSelectedLanguageString = "Hungarian"
    
    public private(set) var languages = TMTranslator.shared.allLanguages
    public private(set) var translateLanguages = TMTranslator.shared.allTranslateLanguages
}
