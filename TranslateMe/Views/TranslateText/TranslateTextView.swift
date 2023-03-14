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
    
    private let upperTranslateTextTextView = TranslateTextTextView(translateOrderLabel: "Translate from")
    private let bottomTranslateTextTextView = TranslateTextTextView(translateOrderLabel: "Translate to", allowEditingTextView: false)
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
        addSubview(upperTranslateTextTextView)
        addSubview(bottomTranslateTextTextView)
        
        NSLayoutConstraint.activate([
            translateBetweenTwoLanguageSelectorView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            translateBetweenTwoLanguageSelectorView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: translateBetweenTwoLanguageSelectorView.trailingAnchor, multiplier: 2),
            
            upperTranslateTextTextView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            upperTranslateTextTextView.topAnchor.constraint(equalToSystemSpacingBelow: translateBetweenTwoLanguageSelectorView.bottomAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: upperTranslateTextTextView.trailingAnchor, multiplier: 2),
            
            bottomTranslateTextTextView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            bottomTranslateTextTextView.topAnchor.constraint(equalToSystemSpacingBelow: upperTranslateTextTextView.bottomAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: bottomTranslateTextTextView.trailingAnchor, multiplier: 2),
        ])
    }
    
    private func configureViews() {
        translateBetweenTwoLanguageSelectorView.configure(leftLanguageString: viewModel.leftSelectedLanguageString, rightLanguageString: viewModel.rightSelectedLanguageString)
        upperTranslateTextTextView.configure(languageString: viewModel.leftSelectedLanguageString)
        bottomTranslateTextTextView.configure(languageString: viewModel.rightSelectedLanguageString)
    }
    
    // MARK: - Selectors
    
}

extension TranslateTextView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}

extension TranslateTextView: TranslateBetweenTwoLanguageSelectorViewDelegate {
    func didPressSwapLanguagesButton() {
        viewModel.switchLanguages()
        self.configureViews()
    }
    
    func didPressSelectLanguage(languageLabel: MainLanguageNameLabelView) {
        let alert = UIAlertController(title: "Select Language", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { action in
            let selectedIndex = self.languagePickerView.selectedRow(inComponent: 0)
            let selectedLanguage = self.viewModel.translateLanguages[selectedIndex]
            let selectedLanguageString = self.viewModel.languages[selectedIndex]
            languageLabel.configure(withLanguage: selectedLanguageString)
            if languageLabel.left {
                self.viewModel.leftSelectedLanguage = selectedLanguage
                self.viewModel.leftSelectedLanguageString = selectedLanguageString
            } else {
                self.viewModel.rightSelectedLanguage = selectedLanguage
                self.viewModel.rightSelectedLanguageString = selectedLanguageString
            }
            self.configureViews()
        }))
        delegate?.showPickerViewAlert(pickerView: self.languagePickerView, alert: alert)
    }
}
