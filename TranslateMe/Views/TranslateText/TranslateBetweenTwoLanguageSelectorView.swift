//
//  TranslateBetweenTwoLanguageSelectorView.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import UIKit

class TranslateBetweenTwoLanguageSelectorView: UIView {

    // MARK: - Properties
    
    private let translateItemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemBackground
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let centerSwitchLanguagesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.left.arrow.right"), for: .normal)
        return button
    }()
    
    private let leftLanguageLabelView = MainLanguageNameLabelView()
    private let rightLanguageLabelView = MainLanguageNameLabelView()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        let height = translateItemsStackView.bounds.height + 36 //Added +36 because of the top and bottomAnchor multipler 2-2
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        addBasicShadow()
        
        addSubview(translateItemsStackView)
        translateItemsStackView.addArrangedSubview(leftLanguageLabelView)
        translateItemsStackView.addArrangedSubview(centerSwitchLanguagesButton)
        translateItemsStackView.addArrangedSubview(rightLanguageLabelView)
        
        NSLayoutConstraint.activate([
            translateItemsStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            translateItemsStackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: translateItemsStackView.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: translateItemsStackView.bottomAnchor, multiplier: 2),
        ])
    }
    
    // MARK: - Selectors
    
}

