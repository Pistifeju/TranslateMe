//
//  CameraToolbarButton.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 19..
//

import Foundation
import UIKit

enum ToolbarButtonType {
    case photos
    case takePicture
    case flashlight
    case leftSpeech
    case rightSpeech
    case reset
    
    var iconImage: UIImage? {
        switch self {
        case .photos:
            return UIImage(systemName: "photo.on.rectangle", withConfiguration: iconImageConfig)
        case .takePicture:
            return UIImage(systemName: "camera", withConfiguration: iconImageConfig)
        case .flashlight:
            return UIImage(systemName: "flashlight.off.fill", withConfiguration: iconImageConfig)
        case .reset:
            return UIImage(systemName: "arrow.clockwise", withConfiguration: iconImageConfig)
        default:
            return UIImage(systemName: "mic", withConfiguration: iconImageConfig)
        }
    }
    
    var iconImageConfig: UIImage.SymbolConfiguration {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(20), weight: .regular, scale: .large)
        return config
    }
    
    var size: Double {
        return 60
    }
}

class CameraToolbarButton: UIButton {
    public var toolbarType: ToolbarButtonType {
        didSet {
            setImage(toolbarType.iconImage, for: .normal)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            switch toolbarType {
            case .flashlight:
                backgroundColor = isSelected ? .label : .secondarySystemBackground
            case .rightSpeech, .leftSpeech:
                backgroundColor = isSelected ? .label : .secondarySystemBackground
            default:
                break
            }
        }
    }
    
    init(toolbarType: ToolbarButtonType) {
        self.toolbarType = toolbarType
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: toolbarType.size, height: toolbarType.size)
    }
    
    private func configureUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = toolbarType.size / 2
        setImage(toolbarType.iconImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
