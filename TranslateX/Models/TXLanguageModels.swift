//
//  TXLanguageModels.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 15..
//

import Foundation
import MLKitTranslate

final class TXLanguageModels {
    
    static let shared = TXLanguageModels()
    
    private init () {}
    
    private var translator: Translator!
    
    public var localModels: [TranslateLanguage] {
        let models = ModelManager.modelManager().downloadedTranslateModels.compactMap({
            return $0.language
        })
        return models
    }
        
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
    
    public func checkIfLanguageInDownloadedLanguages(language: TranslateLanguage) -> Bool {
        return localModels.contains { $0 == language }
    }
    
    public func deleteLanguage(language: TranslateLanguage, completion: @escaping (Bool) -> Void) {
        let model = TranslateRemoteModel.translateRemoteModel(language: language)
        ModelManager.modelManager().deleteDownloadedModel(model) { error in
            guard error == nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
}
