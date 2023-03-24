//
//  TXLanguageIdentifier.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 17..
//

import Foundation
import NaturalLanguage
import MLKitLanguageID

final class TXLanguageIdentifier {
    static let shared = TXLanguageIdentifier()
    
    private init () {}
    
    private var languageIdentifier: MLKitLanguageID.LanguageIdentification!
    
    public func identifyLanguage(for text: String, completion: @escaping (String?, Error?) -> Void) {
        let options = LanguageIdentificationOptions(confidenceThreshold: 0.8)
        languageIdentifier = MLKitLanguageID.LanguageIdentification.languageIdentification(options: options)
        languageIdentifier.identifyPossibleLanguages(for: text) { [weak self] languageCodes, error in
            guard self != nil else { return }
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let identifiedLanguages = languageCodes,
                  !identifiedLanguages.isEmpty,
                  identifiedLanguages[0].languageTag != "und" else {
                completion(nil, nil)
                return
            }
            
            guard let identifiedLanguage = identifiedLanguages.first(where: { TXLanguages.shared.allLanguagesCode.contains($0.languageTag) }) else {
                completion(nil, nil)
                return
            }
            completion(identifiedLanguage.languageTag, nil)
        }
    }
}
