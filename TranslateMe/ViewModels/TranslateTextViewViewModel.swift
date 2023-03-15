//
//  TranslateTextViewViewModel.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import MLKitTranslate

final class TranslateTextViewViewModel {
    
    public var languagePair = TMLanguagePair(sourceLanguage: .english, targetLanguage: .hungarian)
        
    public private(set) var localModels = ModelManager.modelManager().downloadedTranslateModels
}
