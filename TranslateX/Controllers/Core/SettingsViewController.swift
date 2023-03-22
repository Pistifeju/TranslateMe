//
//  SettingsViewController.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 15..
//

import SafariServices
import Foundation
import UIKit
import SwiftUI

final class SettingsViewController: UIViewController {
    
    @Environment(\.openURL) private var openURL

    // MARK: - Properties
    
    private var settingsSwiftUIView: UIHostingController<SettingsView>?
    
    private lazy var viewModel = SettingsViewControllerViewModel(
        cellViewModels: SettingsOption.allCases.compactMap({
            return SettingsCellViewModel(type: $0) { [weak self] option in
                self?.handleTap(option: option)
            }
        })
    )
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Settings"
        addSwiftUISettingsView()
    }
    
    private func addSwiftUISettingsView() {
        let settingsSwiftUIController = UIHostingController(
            rootView: SettingsView(
                viewModel: viewModel )
        )
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            settingsSwiftUIController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsSwiftUIController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
        
        self.settingsSwiftUIView = settingsSwiftUIController
    }
    
    private func handleTap(option: SettingsOption) {
        guard Thread.current.isMainThread else {
            return
        }
        
        if let url = option.targetUrl {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option == .rateApp {
            viewModel.rateApp(viewController: self)
        } else if option == .languages {
            let vc = LanguagesViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if option == .contactUs {
            viewModel.email.send(openURL: openURL)
        }
    }
    
    // MARK: - Selectors
}
