//
//  TranslateConversationViewController.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 13..
//

import Foundation
import UIKit

final class TranslateConversationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let conversationView = ConversationView(viewModel: ConversationViewViewModel())
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conversationView.delegate = self
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Conversation"

        view.addSubview(conversationView)
        
        NSLayoutConstraint.activate([
            conversationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            conversationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            conversationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            conversationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors
}

// MARK: - ConversationViewDelegate

extension TranslateConversationViewController: ConversationViewDelegate {
    func showCreatedAlertControllerError(ac: UIAlertController) {
        present(ac, animated: true)
    }
    
    func handleShowErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alertController, animated: true)
    }
    
    func showPickerViewAlert(pickerView: UIPickerView, alert: UIAlertController) {
        self.showLanguagePickerView(pickerView: pickerView, alert: alert)
    }
}
