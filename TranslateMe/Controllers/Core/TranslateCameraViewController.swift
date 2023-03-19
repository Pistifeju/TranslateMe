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
        
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopRunningCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cameraModel = TMCamera()
        cameraModel.checkPermissions { [weak self] success in
            switch success {
            case true:
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.viewModel.startRunningCaptureSession()
                }
            case false:
                let alert = cameraModel.handlePermissionFailed()
                self?.present(alert, animated: true)
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
