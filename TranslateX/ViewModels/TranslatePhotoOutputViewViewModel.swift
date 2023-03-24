//
//  TranslatePhotoOutputViewViewModel.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 23..
//

import Foundation
import UIKit

final class TranslatePhotoOutputViewViewModel: TranslateViewModel {
    
    public var sourceTextHeight: CGFloat {
        return languagePair.sourceText.calculateLabelHeight(with: UIScreen.main.bounds.width - 62, for: UIFont.preferredFont(forTextStyle: .body)).height + 20
    }
    
    public var targetTextHeight: CGFloat {
        return languagePair.targetText.calculateLabelHeight(with: UIScreen.main.bounds.width - 62, for: UIFont.preferredFont(forTextStyle: .body)).height + 20
    }
    
    init(languagePair: TXLanguagePair) {
        super.init()
        self.languagePair = languagePair
    }
    
    public func createTargetText(completion: @escaping (String) -> Void) {
        let lines = languagePair.sourceText.components(separatedBy: "\n")
        var translatedLines: [String] = []
        let dispatchGroup = DispatchGroup()

        for line in lines {
            let lineLanguagePair = TXLanguagePair(sourceLanguage: languagePair.sourceLanguage, targetLanguage: languagePair.targetLanguage)
            lineLanguagePair.sourceText = line
            dispatchGroup.enter()
            lineLanguagePair.translate(from: lineLanguagePair.sourceLanguage, to: lineLanguagePair.targetLanguage, translateFromTarget: false) { [weak self] in
                guard self != nil else { return }
                translatedLines.append(lineLanguagePair.targetText)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(translatedLines.joined(separator: "\n"))
        }
    }
}
