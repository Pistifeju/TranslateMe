//
//  CameraView.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import UIKit
import AVFoundation

protocol CameraViewDelegate: AnyObject {
    func showPhotoPickerView()
}

class CameraView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CameraViewDelegate?
    
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
    
    public let captureImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isHidden = true
        return iv
    }()
    
    public var imageViewImage: UIImage? {
        didSet {
            captureImageView.image = imageViewImage

            if imageViewImage != nil {
                captureImageView.isHidden = false
                toolbarView.configurePictureButton(isSelected: true)
            } else {
                captureImageView.isHidden = true
                toolbarView.configurePictureButton(isSelected: false)
            }
        }
    }
    
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
        addSubview(captureImageView)
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
            
            captureImageView.topAnchor.constraint(equalToSystemSpacingBelow: translateBetweenTwoLanguageSelectorView.bottomAnchor, multiplier: 2),
            captureImageView.bottomAnchor.constraint(equalTo: toolbarView.topAnchor),
            captureImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            captureImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
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
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        strongSelf.viewModel.captureSession.startRunning()
                        DispatchQueue.main.async {
                            strongSelf.layoutIfNeeded()
                            strongSelf.viewModel.videoPreviewLayer.frame = strongSelf.captureImageView.frame
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

extension CameraView: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else { return }
        guard let imageData = photo.fileDataRepresentation()
        else { return }
        
        let image = UIImage(data: imageData)
        imageViewImage = image
        viewModel.stopRunningCaptureSession()
    }
}

// MARK: - CameraToolbarViewDelegate

extension CameraView: CameraToolbarViewDelegate {
    func didPressToolbarButton(button: CameraToolbarButton) {
        switch button.toolbarType {
        case .photos:
            delegate?.showPhotoPickerView()
        case .takePicture:
            if button.isSelected {
                imageViewImage = nil
                viewModel.startRunningCaptureSession()
            } else {
                let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                viewModel.stillImageOutput.capturePhoto(with: settings, delegate: self)
                captureImageView.isHidden = false
            }
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
