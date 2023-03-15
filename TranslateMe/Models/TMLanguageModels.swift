//
//  TMLanguageModels.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 15..
//

import Foundation
import MLKitTranslate

final class TMLanguageModels {
    
    public static let shared = TMLanguageModels()
    
    private init () {}
    
    private var translator: Translator!
    
    public private(set) var localModels = ModelManager.modelManager().downloadedTranslateModels
    
    public func downloadLanguageIfNeeded(sourceLanguage: TranslateLanguage, targetLanguage: TranslateLanguage, completion: @escaping(Error?) -> Void) {
        let options = TranslatorOptions(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
        translator = Translator.translator(options: options)
        
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else {
                completion(error)
                return
            }
            completion(nil)
            return
        }
    }
}
