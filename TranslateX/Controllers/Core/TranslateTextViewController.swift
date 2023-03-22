//
//  TranslateTextViewController.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 13..
//

import Foundation
import UIKit
import MLKitTranslate

final class TranslateTextViewController: UIViewController {
    
    // MARK: - Properties
        
    private lazy var translateTextView = TranslateTextView()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateTextView.delegate = self

        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(translateTextView)
        navigationItem.title = "Text"
        NSLayoutConstraint.activate([
            translateTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            translateTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            translateTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            translateTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors
}

// MARK: - TranslateTextViewDelegate

extension TranslateTextViewController: TranslateTextViewDelegate {
    func handleShowIdentifiedLanguageNotDownloadedAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Language Not Downloaded", message: "The language you selected is not currently downloaded. Do you want to download it?", preferredStyle: .alert)

        let downloadAction = UIAlertAction(title: "Download", style: .default) { (_) in
            completion(true)
            return
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            completion(false)
            return
        }

        alert.addAction(downloadAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    func handleShowErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alertController, animated: true)
    }
    
    func handleSpeechPermissionFailed(ac: UIAlertController) {
        present(ac, animated: true)
    }
    
    func showPickerViewAlert(pickerView: UIPickerView, alert: UIAlertController) {
        self.showLanguagePickerView(pickerView: pickerView, alert: alert)
    }
}
