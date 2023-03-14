//
//  TranslateTextViewController.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 13..
//

import Foundation
import UIKit

final class TranslateTextViewController: UIViewController {
    
    // MARK: - Properties
    
    private let translateTextView = TranslateTextView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(translateTextView)
        navigationItem.title = "TranslateMe - Text"
        
        NSLayoutConstraint.activate([
            translateTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            translateTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            translateTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            translateTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors
}
