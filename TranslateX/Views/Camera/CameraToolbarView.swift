//
//  CameraToolbarView.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 19..
//

import Foundation
import UIKit

protocol CameraToolbarViewDelegate: AnyObject {
    func didPressToolbarButton(button: CameraToolbarButton)
}

class CameraToolbarView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CameraToolbarViewDelegate?
    
    private let leftButton: CameraToolbarButton
    private let middleButton: CameraToolbarButton
    private let rightButton: CameraToolbarButton
    
    // MARK: - Lifecycle
    
    override var intrinsicContentSize: CGSize {
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height / 7)
    }
    
    init(toolBarButtonTypes: [ToolbarButtonType]) {
        self.leftButton = CameraToolbarButton(toolbarType: toolBarButtonTypes[0])
        self.middleButton = CameraToolbarButton(toolbarType: toolBarButtonTypes[1])
        self.rightButton = CameraToolbarButton(toolbarType: toolBarButtonTypes[2])
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        leftButton.addTarget(self, action: #selector(didTapToolbarButton(_:)), for: .touchUpInside)
        middleButton.addTarget(self, action: #selector(didTapToolbarButton(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(didTapToolbarButton(_:)), for: .touchUpInside)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [leftButton, middleButton, rightButton])
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
    
    public func configurePictureButton() {
        middleButton.isSelected.toggle()
        middleButton.toolbarType = middleButton.toolbarType == .takePicture ? .reset : .takePicture
    }
    
    // MARK: - Selectors
    
    @objc private func didTapToolbarButton(_ button: CameraToolbarButton) {
        switch button.toolbarType {
        case .leftSpeech:
            rightButton.isSelected = false
        case .rightSpeech:
            leftButton.isSelected = false
        case .reset where leftButton.toolbarType == .leftSpeech:
            leftButton.isSelected = false
            rightButton.isSelected = false
        default:
            break
        }
        
        button.isSelected.toggle()
        delegate?.didPressToolbarButton(button: button)
    }
}

