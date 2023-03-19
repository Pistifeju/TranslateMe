//
//  CameraView.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import UIKit
import AVFoundation

class CameraView: UIView {
    
    // MARK: - Properties
    
    private var viewModel: CameraViewViewModel
    
    private let translateBetweenTwoLanguageSelectorView = TranslateBetweenTwoLanguageSelectorView()
    
    private let toolbarView = CameraToolbarView()
    
    private let cameraNotAvailableLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Camera is currently unavailable. Please enable it in your device's settings."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: CameraViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        translateBetweenTwoLanguageSelectorView.delegate = self
        toolbarView.delegate = self
        setupCamera()
        configureUI()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        addSubview(translateBetweenTwoLanguageSelectorView)
        addSubview(toolbarView)
        addSubview(cameraNotAvailableLabel)
        
        NSLayoutConstraint.activate([
            translateBetweenTwoLanguageSelectorView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            translateBetweenTwoLanguageSelectorView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: translateBetweenTwoLanguageSelectorView.trailingAnchor, multiplier: 2),
            
            toolbarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbarView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            cameraNotAvailableLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            cameraNotAvailableLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: cameraNotAvailableLabel.trailingAnchor, multiplier: 2),
        ])
    }
    
    private func configureViews(speakButtonIsSelected: Bool = false) {
        let languagePair = viewModel.languagePair
        self.translateBetweenTwoLanguageSelectorView.configure(sourceLanguageString: languagePair.sourceLanguageString, targetLanguageString: languagePair.targetLanguageString)
    }
    
    private func setupCamera() {
        if viewModel.isCameraEnabled {
            viewModel.setupCameraPreviewLayer { [weak self] error in
                guard let strongSelf = self else { return }
                if let error {
                    // TODO: - Show error alert here
                    print(error)
                } else {
                    strongSelf.layer.addSublayer(strongSelf.viewModel.videoPreviewLayer)
                    
                    let width = UIScreen.main.bounds.width
                    let height = UIScreen.main.bounds.height
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.viewModel.captureSession.startRunning()
                        DispatchQueue.main.async {
                            strongSelf.viewModel.videoPreviewLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
                        }
                    }
                }
            }
        } else {
            cameraNotAvailableLabel.isHidden = false
        }
    }
    
    // MARK: - Selectors
    
}

// MARK: - CameraToolbarViewDelegate

extension CameraView: CameraToolbarViewDelegate {
    func didPressToolbarButton(option: ToolbarButtonType) {
        switch option {
        case .photos:
            break
        case .takePicture:
            break
        case .flashlight:
            viewModel.toggleFlash()
        }
    }
}

// MARK: - TranslateBetweenTwoLanguageSelectorViewDelegate

extension CameraView: TranslateBetweenTwoLanguageSelectorViewDelegate {
    func didPressSelectLanguage(languageLabel: MainLanguageNameLabelView) {
        // TODO: Implement
    }
    
    func didPressSwitchLanguagesButton() {
        viewModel.languagePair.switchLanguages()
        configureViews()
    }
}
