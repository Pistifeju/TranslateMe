//
//  LanguagesViewController.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import UIKit

class LanguagesViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Languages"
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    // MARK: - Selectors
}
