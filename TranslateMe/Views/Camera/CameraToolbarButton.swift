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
    
    var iconImage: UIImage? {
        let size = self == .takePicture ? 25 : 20
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(size), weight: .regular, scale: .large)
        switch self {
        case .photos:
            return UIImage(systemName: "photo.on.rectangle", withConfiguration: config)
        case .takePicture:
            return UIImage(systemName: "camera", withConfiguration: config)
        case .flashlight:
            return UIImage(systemName: "flashlight.off.fill", withConfiguration: config)
        }
    }
    
    var size: Double {
        return 60
    }
}

class CameraToolbarButton: UIButton {
    
    public let toolbarType: ToolbarButtonType
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .label : .secondarySystemBackground
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
        backgroundColor = isSelected ? .label : .secondarySystemBackground
        layer.cornerRadius = toolbarType.size / 2
        setImage(toolbarType.iconImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
