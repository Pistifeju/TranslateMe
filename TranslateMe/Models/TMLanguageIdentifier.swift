//
//  TMLanguageIdentifier.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 17..
//

import Foundation
import NaturalLanguage
import MLKitLanguageID

final class TMLanguageIdentifier {
    public static let shared = TMLanguageIdentifier()
    
    private init () {}
    
    private let languageIdentifier = MLKitLanguageID.LanguageIdentification.languageIdentification()
    
    public func identifyLanguage(for text: String, completion: @escaping (String?, Error?) -> Void) {
        languageIdentifier.identifyPossibleLanguages(for: text) { languageCodes, error in
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
            
            guard let identifiedLanguage = identifiedLanguages.first(where: { TMLanguages.shared.allLanguagesCode.contains($0.languageTag) }) else {
                completion(nil, nil)
                return
            }
            completion(identifiedLanguage.languageTag, nil)
        }
    }
}
