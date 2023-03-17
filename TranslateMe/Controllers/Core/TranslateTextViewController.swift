//
//  TranslateTextViewController.swift
//  TranslateMe
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

extension TranslateTextViewController: TranslateTextViewDelegate {
    func handleShowErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alertController, animated: true)
    }
    
    func handleSpeechPermissionFailed(ac: UIAlertController) {
        present(ac, animated: true)
    }
    
    func showPickerViewAlert(pickerView: UIPickerView, alert: UIAlertController) {
        let vc = UIViewController()
        let height = UIScreen.main.bounds.height / 2
        let width = UIScreen.main.bounds.width - 16
        vc.preferredContentSize = CGSize(width: width, height: height)
        vc.view.addSubview(pickerView)
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.topAnchor.constraint(equalTo: vc.view.topAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
        alert.setValue(vc, forKey: "contentViewController")
        navigationController?.present(alert, animated: true)
    }
}
