//
//  TranslateTextView.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import UIKit

protocol TranslateTextViewDelegate: AnyObject {
    func showPickerViewAlert(pickerView: UIPickerView, alert: UIAlertController)
}

final class TranslateTextView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: TranslateTextViewDelegate?
    
    private var viewModel = TranslateTextViewViewModel()
    
    private let sourceTranslateTextTextView = TranslateTextTextView(translateOrderLabel: "Translate from")
    private let targetTranslateTextTextView = TranslateTextTextView(translateOrderLabel: "Translate to", allowEditingTextView: false)
    private let translateBetweenTwoLanguageSelectorView = TranslateBetweenTwoLanguageSelectorView()
    
    private let languagePickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: .zero)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        translateBetweenTwoLanguageSelectorView.delegate = self
        languagePickerView.delegate = self
        languagePickerView.dataSource = self
        sourceTranslateTextTextView.delegate = self
        configureViews()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        addSubview(translateBetweenTwoLanguageSelectorView)
        addSubview(sourceTranslateTextTextView)
        addSubview(targetTranslateTextTextView)
        
        NSLayoutConstraint.activate([
            translateBetweenTwoLanguageSelectorView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            translateBetweenTwoLanguageSelectorView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: translateBetweenTwoLanguageSelectorView.trailingAnchor, multiplier: 2),
            
            sourceTranslateTextTextView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            sourceTranslateTextTextView.topAnchor.constraint(equalToSystemSpacingBelow: translateBetweenTwoLanguageSelectorView.bottomAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: sourceTranslateTextTextView.trailingAnchor, multiplier: 2),
            
            targetTranslateTextTextView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            targetTranslateTextTextView.topAnchor.constraint(equalToSystemSpacingBelow: sourceTranslateTextTextView.bottomAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: targetTranslateTextTextView.trailingAnchor, multiplier: 2),
        ])
    }
    
    private func configureViews() {
        let languagePair = viewModel.languagePair
        translateBetweenTwoLanguageSelectorView.configure(sourceLanguageString: languagePair.sourceLanguageString, targetLanguageString: languagePair.targetLanguageString)
        sourceTranslateTextTextView.configure(languageString: languagePair.sourceLanguageString)
        targetTranslateTextTextView.configure(languageString: languagePair.targetLanguageString)
    }
    
    // MARK: - Selectors
    
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension TranslateTextView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TMLanguages.shared.allTranslateLanguages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TMLanguages.shared.allLanguages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}

// MARK: - TranslateBetweenTwoLanguageSelectorViewDelegate

extension TranslateTextView: TranslateBetweenTwoLanguageSelectorViewDelegate {
    func didPressSwapLanguagesButton() {
        viewModel.languagePair.switchLanguages()
        self.configureViews()
    }
    
    func didPressSelectLanguage(languageLabel: MainLanguageNameLabelView) {
        let alert = UIAlertController(title: "Select Language", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { action in
            let selectedIndex = self.languagePickerView.selectedRow(inComponent: 0)
            let selectedLanguage = TMLanguages.shared.allTranslateLanguages[selectedIndex]
            let selectedLanguageString = TMLanguages.shared.allLanguages[selectedIndex]
            languageLabel.configure(withLanguage: selectedLanguageString)
            if languageLabel.source {
                self.viewModel.languagePair.sourceLanguage = selectedLanguage
            } else {
                self.viewModel.languagePair.targetLanguage = selectedLanguage
            }
            self.configureViews()
        }))
        delegate?.showPickerViewAlert(pickerView: self.languagePickerView, alert: alert)
    }
}

// MARK: - TranslateTextViewDelegate

extension TranslateTextView: TranslateTextTextViewDelegate {
    func textViewDidChange(textViewString: String) {
        
    }
}
