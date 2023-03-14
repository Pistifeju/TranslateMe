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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "TranslateMe - Camera"
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    // MARK: - Selectors
}
