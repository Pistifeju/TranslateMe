//
//  MainTabBarViewController.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 13..
//

import Foundation
import UIKit

class MainTabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    private let viewModel = MainTabBarViewControllerViewModel()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let isDarkModeOn = UserDefaults.standard.object(forKey: "isDarkModeOn") as? Bool {
            let window = UIApplication.shared.windows.first
            window?.overrideUserInterfaceStyle = isDarkModeOn ? .dark : .light
        }
        viewControllers = viewModel.createNavigationControllers()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.shadowColor = UIColor.secondaryLabel.cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
    }
    
    // MARK: - Selectors
}
