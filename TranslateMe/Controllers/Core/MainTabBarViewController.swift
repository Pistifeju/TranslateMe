//
//  MainTabBarViewController.swift
//  TranslateMe
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
        viewControllers = viewModel.createNavigationControllers()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
    }
    
    // MARK: - Selectors
}
