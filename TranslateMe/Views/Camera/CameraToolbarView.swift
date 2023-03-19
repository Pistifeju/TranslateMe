//
//  CameraToolbarView.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 19..
//

import Foundation
import UIKit

protocol CameraToolbarViewDelegate: AnyObject {
    func didPressToolbarButton(option: ToolbarButtonType)
}

class CameraToolbarView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CameraToolbarViewDelegate?
    
    private let photosButton = CameraToolbarButton(toolbarType: .photos)
    private let takePictureButton = CameraToolbarButton(toolbarType: .takePicture)
    private let flashlightButton = CameraToolbarButton(toolbarType: .flashlight)
    
    // MARK: - Lifecycle
    
    override var intrinsicContentSize: CGSize {
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height / 7)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        photosButton.addTarget(self, action: #selector(didTapToolbarButton(_:)), for: .touchUpInside)
        takePictureButton.addTarget(self, action: #selector(didTapToolbarButton(_:)), for: .touchUpInside)
        flashlightButton.addTarget(self, action: #selector(didTapToolbarButton(_:)), for: .touchUpInside)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [photosButton, takePictureButton, flashlightButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2)
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didTapToolbarButton(_ button: CameraToolbarButton) {
        let type = button.toolbarType
        delegate?.didPressToolbarButton(option: type)
        if type == .flashlight {
            flashlightButton.isSelected.toggle()
        }
    }
}

