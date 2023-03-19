//
//  TranslateCameraViewController.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 13..
//

import Foundation
import UIKit

final class TranslateCameraViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = CameraViewViewModel()
    
    private lazy var cameraView = CameraView(viewModel: viewModel)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        cameraView.delegate = self
        
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopRunningCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !viewModel.askedForCameraPermission {
            viewModel.askedForCameraPermission = true
            TMPermissions.shared.checkCameraPermission { [weak self] success in
                switch success {
                case true:
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        self?.viewModel.startRunningCaptureSession()
                    }
                case false:
                    let alert = TMPermissions.shared.handlePermissionFailed(
                        title: "The app must have access to the camera to use the camera translating feature.",
                        message: "Please consider updating your settings.")
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Camera"
        view.addSubview(cameraView)
        
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
}

// MARK: - CameraViewDelegate

extension TranslateCameraViewController: CameraViewDelegate {
    func showCameraNotAvailableAlert() {
        let alert = TMPermissions.shared.handlePermissionFailed(
            title: "The app must have access to the camera to use the camera translating feature.",
            message: "Please consider updating your settings.")
        present(alert, animated: true)
    }
    
    func showPhotoPickerView() {
        TMPermissions.shared.checkPhotoLibraryPermission { [weak self] success in
            switch success {
            case true:
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.delegate = self
                vc.allowsEditing = true
                self?.present(vc, animated: true)
            case false:
                let alert = TMPermissions.shared.handlePermissionFailed(
                    title: "The app must have access to the photo library to load a photo.",
                    message: "Please consider updating your settings.")
                self?.present(alert, animated: true)
            }
        }
    }
}

extension TranslateCameraViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            viewModel.stopRunningCaptureSession()
            cameraView.imageViewImage = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
