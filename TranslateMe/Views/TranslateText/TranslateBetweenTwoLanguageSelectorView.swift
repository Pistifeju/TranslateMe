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
    func didPressSwapLanguagesButton()
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
    
    private let leftLanguageLabelView = MainLanguageNameLabelView(left: true)
    private let rightLanguageLabelView = MainLanguageNameLabelView(left: false)
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        leftLanguageLabelView.delegate = self
        rightLanguageLabelView.delegate = self
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
        
        addSubview(leftLanguageLabelView)
        addSubview(centerSwitchLanguagesButton)
        addSubview(rightLanguageLabelView)
        
        NSLayoutConstraint.activate([
            leftLanguageLabelView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            leftLanguageLabelView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            centerSwitchLanguagesButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            centerSwitchLanguagesButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            trailingAnchor.constraint(equalToSystemSpacingAfter: rightLanguageLabelView.trailingAnchor, multiplier: 2),
            rightLanguageLabelView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public func configure(leftLanguageString: String, rightLanguageString: String) {
        leftLanguageLabelView.configure(withLanguage: leftLanguageString)
        rightLanguageLabelView.configure(withLanguage: rightLanguageString)
    }
    
    // MARK: - Selectors
    
    @objc private func didTapSwitchLanguagesButton() {
        delegate?.didPressSwapLanguagesButton()
    }
}

extension TranslateBetweenTwoLanguageSelectorView: MainLanguageNameLabelViewDelegate {
    func didPressLanguageLabel(sender: MainLanguageNameLabelView) {
        delegate?.didPressSelectLanguage(languageLabel: sender)
    }
}
