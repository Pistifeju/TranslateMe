//
//  TranslatePhotoOutputViewController.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 23..
//

import Foundation
import UIKit
import SwiftUI

class TranslatePhotoOutputViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: TranslatePhotoOutputViewViewModel
    
    private var photoOutputSwiftUIView: UIHostingController<PhotoOutputView>?
    
    // MARK: - LifeCycle
    
    init(viewModel: TranslatePhotoOutputViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Translation"
        configureUI()
        addSwiftUIPhotoOutputView()
    }
    
    // MARK: - Helpers
    
    private func addSwiftUIPhotoOutputView() {
        let photoOutputSwiftUIController = UIHostingController(
            rootView: PhotoOutputView(
                viewModel: viewModel )
        )
        
        addChild(photoOutputSwiftUIController)
        photoOutputSwiftUIController.didMove(toParent: self)
        
        view.addSubview(photoOutputSwiftUIController.view)
        photoOutputSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoOutputSwiftUIController.view.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            photoOutputSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoOutputSwiftUIController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoOutputSwiftUIController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
        
        self.photoOutputSwiftUIView = photoOutputSwiftUIController
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Selectors
}
