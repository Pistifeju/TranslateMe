//
//  CameraView.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import UIKit
import AVFoundation
import VisionKit

protocol CameraViewDelegate: AnyObject {
    func showPhotoPickerView()
    func showCameraNotAvailableAlert()
    func showPickerViewAlert(pickerView: UIPickerView, alert: UIAlertController)
}

class CameraView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CameraViewDelegate?
    
    private let liveTextInteraction = ImageAnalysisInteraction()
    private let liveTextAnalyzer = ImageAnalyzer()
    
    private var viewModel: CameraViewViewModel
    
    private let translateBetweenTwoLanguageSelectorView = TranslateBetweenTwoLanguageSelectorView()
    
    private let toolbarView = CameraToolbarView(toolBarButtonTypes: [.photos, .takePicture, .flashlight])
    
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
    
    private let languagePickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: .zero)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    public lazy var captureImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isHidden = true
        return iv
    }()
    
    public var imageViewImage: UIImage? {
        didSet {
            liveTextInteraction.preferredInteractionTypes = []
            liveTextInteraction.analysis = nil
            captureImageView.image = imageViewImage
            if let imageViewImage {
                captureImageView.isHidden = false
                toolbarView.configurePictureButton(isSelected: true)
                Task.init {
                    await setupLiveText(image: imageViewImage)
                }
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
        languagePickerView.delegate = self
        captureImageView.addInteraction(liveTextInteraction)
        liveTextInteraction.delegate = self
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
        addSubview(cameraNotAvailableLabel)
        addSubview(captureImageView)
        addSubview(translateBetweenTwoLanguageSelectorView)
        addSubview(toolbarView)
        
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
    
    private func configureViews() {
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
    
    
    private func setupLiveText(image: UIImage) async {
        liveTextInteraction.preferredInteractionTypes = .textSelection
        
        let liveTextConfiguration = ImageAnalyzer.Configuration([.text])
        do {
            let analysis = try await liveTextAnalyzer.analyze(image, configuration: liveTextConfiguration)
            liveTextInteraction.analysis = analysis
        } catch let error {
            print(error)
        }
        
    }
    
    // MARK: - Selectors
    
}

// MARK: - ImageAnalysisInteractionDelegate

extension CameraView: ImageAnalysisInteractionDelegate {
    
}

// MARK: - AVCapturePhotoCaptureDelegate

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

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension CameraView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TMLanguageModels.shared.localModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TMLanguages.shared.createLanguageStringWithTranslateLanguage(from: TMLanguageModels.shared.localModels[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 10
    }
}

// MARK: - CameraToolbarViewDelegate

extension CameraView: CameraToolbarViewDelegate {
    func didPressToolbarButton(button: CameraToolbarButton) {
        switch button.toolbarType {
        case .photos:
            delegate?.showPhotoPickerView()
        case .takePicture:
            TMPermissions.shared.checkCameraPermission { [weak self] success in
                guard let strongSelf = self else { return }
                switch success {
                case true:
                    let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                    strongSelf.viewModel.stillImageOutput.capturePhoto(with: settings, delegate: strongSelf)
                    strongSelf.captureImageView.isHidden = false
                    button.toolbarType = .reset
                case false:
                    strongSelf.delegate?.showCameraNotAvailableAlert()
                }
            }
        case .flashlight:
            viewModel.toggleFlash()
        case .reset:
            imageViewImage = nil
            viewModel.stopRunningCaptureSession()
            button.toolbarType = .takePicture
        default:
            break
        }
    }
}

// MARK: - TranslateBetweenTwoLanguageSelectorViewDelegate

extension CameraView: TranslateBetweenTwoLanguageSelectorViewDelegate {
    func didPressSelectLanguage(languageLabel: MainLanguageNameLabelView) {
        languagePickerView.reloadAllComponents()
        
        let alert = UIAlertController(title: "Downloaded Languages", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            let selectedIndex = strongSelf.languagePickerView.selectedRow(inComponent: 0)
            let selectedLanguage = TMLanguageModels.shared.localModels[selectedIndex]
            let selectedLanguageString = TMLanguages.shared.createLanguageStringWithTranslateLanguage(from: selectedLanguage)
            
            languageLabel.configure(withLanguage: selectedLanguageString)
            
            if languageLabel.source {
                strongSelf.viewModel.languagePair.sourceLanguage = selectedLanguage
            } else {
                strongSelf.viewModel.languagePair.targetLanguage = selectedLanguage
            }
            
            let languagePair = strongSelf.viewModel.languagePair
            strongSelf.viewModel.languagePair.translate(from: languagePair.sourceLanguage, to: languagePair.targetLanguage, translateFromTarget: false) {
                strongSelf.configureViews()
            }
        }))
        
        delegate?.showPickerViewAlert(pickerView: languagePickerView, alert: alert)
    }

    
    func didPressSwitchLanguagesButton() {
        viewModel.languagePair.switchLanguages()
        configureViews()
    }
}
