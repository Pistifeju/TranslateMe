//
//  LanguagesCellViewModel.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import UIKit
import MLKitTranslate

enum LanguageCellOption {
    case download
    case delete
}

struct LanguagesCellViewModel: Identifiable, Hashable {
    
    public let id = UUID()
    
    public var countryFlag: String {
        return createCountryFlagString()
    }
    
    public var title: String {
        return TXLanguages.shared.createLanguageStringWithTranslateLanguage(from: language)
    }
    
    public var image: UIImage? {
        let imageName = option == .download ? "arrow.down.circle" : "trash.circle"
        return UIImage(systemName: imageName)
    }
    
    public private(set) var language: TranslateLanguage
        
    public private(set) var option: LanguageCellOption
    
    public let onTapHandler: (LanguageCellOption) -> Void
    
    init(language: TranslateLanguage, option: LanguageCellOption, onTapHandler: @escaping (LanguageCellOption) -> Void) {
        self.language = language
        self.option = option
        self.onTapHandler = onTapHandler
    }
    
    private func createCountryFlagString() -> String {
        var countryCode: String = ""
        switch language {
        case .english:
            countryCode = "GB"
        case .czech:
            countryCode = "CZ"
        case .chinese:
            return "🇨🇳"
        case .danish:
            countryCode = "DK"
        case .greek:
            countryCode = "GR"
        case .hindi:
            return ""
        case .hebrew:
            return ""
        case .japanese:
            countryCode = "JP"
        case .korean:
            countryCode = "KR"
        case .ukrainian:
            countryCode = "UA"
        case .swedish:
            countryCode = "SE"
        case .vietnamese:
            countryCode = "VN"
        case .arabic:
            return ""
        default:
            countryCode = language.rawValue.uppercased()
        }
        let base: UInt32 = 127397
        var flag = ""
        for scalar in countryCode.unicodeScalars {
            if let scalarValue = scalar.value as? UInt32 {
                flag.unicodeScalars.append(UnicodeScalar(base + scalarValue)!)
            }
        }
        return flag
    }
    
    static func == (lhs: LanguagesCellViewModel, rhs: LanguagesCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(language)
    }
}
