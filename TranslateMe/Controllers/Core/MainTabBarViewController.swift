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
        view.backgroundColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.shadowColor = UIColor.label.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 1
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowPath = UIBezierPath(rect: tabBar.bounds).cgPath
    }
    
    // MARK: - Selectors
}
