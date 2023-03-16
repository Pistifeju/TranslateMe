//
//  ProfileViewController.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 15..
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Profile"
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    // MARK: - Selectors
}
