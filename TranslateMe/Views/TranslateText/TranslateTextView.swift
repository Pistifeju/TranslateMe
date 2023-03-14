//
//  TranslateTextView.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import UIKit

final class TranslateTextView: UIView {
    
    // MARK: - Properties
    
    private let viewModel = TranslateTextViewViewModel()

    private let upperTranslateTextTextView = TranslateTextTextView(translateOrderLabel: "Translate from")
    private let bottomTranslateTextTextView = TranslateTextTextView(translateOrderLabel: "Translate to")
    private let translateBetweenTwoLanguageSelectorView = TranslateBetweenTwoLanguageSelectorView()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Selectors
    
}

