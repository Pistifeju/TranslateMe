//
//  TranslateBetweenTwoLanguageSelectorView.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import UIKit

protocol TranslateBetweenTwoLanguageSelectorViewDelegate: AnyObject {
    func didPressSelectLanguage(languageLabel: MainLanguageNameLabelView)
    func didPressSwitchLanguagesButton()
}

class TranslateBetweenTwoLanguageSelectorView: UIView {

    // MARK: - Properties
        
    weak var delegate: TranslateBetweenTwoLanguageSelectorViewDelegate?
    
    private let centerSwitchLanguagesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.left.arrow.right"), for: .normal)
        return button
    }()
    
    private let sourceLanguageLabelView = MainLanguageNameLabelView(source: true)
    private let targetLanguageLabelView = MainLanguageNameLabelView(source: false)
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        sourceLanguageLabelView.delegate = self
        targetLanguageLabelView.delegate = self
        centerSwitchLanguagesButton.addTarget(self, action: #selector(didTapSwitchLanguagesButton), for: .touchUpInside)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        let height = centerSwitchLanguagesButton.bounds.height + 36 //Added +36 because of the top and bottomAnchor multipler 2 - 2
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        addBasicShadow()
        
        addSubview(sourceLanguageLabelView)
        addSubview(centerSwitchLanguagesButton)
        addSubview(targetLanguageLabelView)
        
        NSLayoutConstraint.activate([
            sourceLanguageLabelView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            sourceLanguageLabelView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            centerSwitchLanguagesButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            centerSwitchLanguagesButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            trailingAnchor.constraint(equalToSystemSpacingAfter: targetLanguageLabelView.trailingAnchor, multiplier: 2),
            targetLanguageLabelView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public func configure(sourceLanguageString: String, targetLanguageString: String) {
        sourceLanguageLabelView.configure(withLanguage: sourceLanguageString)
        targetLanguageLabelView.configure(withLanguage: targetLanguageString)
    }
    
    // MARK: - Selectors
    
    @objc private func didTapSwitchLanguagesButton() {
        delegate?.didPressSwitchLanguagesButton()
    }
}

// MARK: - MainLanguageNameLabelViewDelegate

extension TranslateBetweenTwoLanguageSelectorView: MainLanguageNameLabelViewDelegate {
    func didPressLanguageLabel(sender: MainLanguageNameLabelView) {
        delegate?.didPressSelectLanguage(languageLabel: sender)
    }
}
