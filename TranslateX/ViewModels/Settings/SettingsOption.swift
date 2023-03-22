//
//  SettingsOption.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 17..
//

import Foundation
import UIKit

enum SettingsOption: CaseIterable {
    case languages
    case darkMode
    case rateApp
    case contactUs
    case terms
    case privacy
    
    var targetUrl: URL? {
        switch self {
        case .languages:
            return nil
        case .darkMode:
            return nil
        case .rateApp:
            return nil
        case .contactUs:
            return nil
        case .terms:
            return URL(string: "https://policies.google.com/terms?hl=en-US")
        case .privacy:
            return URL(string: "https://policies.google.com/privacy?hl=en-US")
        }
    }
    
    var displayTitle: String {
        switch self {
        case .languages:
            return "Languages"
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .darkMode:
            return "Dark Mode"
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        default:
            return .systemBlue
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .languages:
            return UIImage(systemName: "globe")
        case .darkMode:
            return UIImage(systemName: "moon.fill")
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane.fill")
        case .terms:
            return UIImage(systemName: "doc.text.fill")
        case .privacy:
            return UIImage(systemName: "lock.fill")
        }
    }
}
