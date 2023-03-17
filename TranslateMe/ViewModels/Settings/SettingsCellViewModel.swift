//
//  SettingsCellViewModel.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 17..
//

import Foundation
import UIKit

struct SettingsCellViewModel: Identifiable {
    
    public let id = UUID()
    
    public var image: UIImage? {
        return type.iconImage
    }
    public var title: String {
        return type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
    
    public let type: SettingsOption
    
    public let onTapHandler: (SettingsOption) -> Void
    
    init(type: SettingsOption, onTapHandler: @escaping (SettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
}
