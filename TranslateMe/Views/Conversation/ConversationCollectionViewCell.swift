//
//  ConversationCollectionViewCell.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 20..
//

import Foundation
import UIKit

class ConversationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ConversationCollectionViewCell"
    
    private let sourceTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let translatedTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .systemBlue
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondaryLabel
        view.alpha = 0.3
        return view
    }()
    
    // MARK: - Lifecycle
    
    override var intrinsicContentSize: CGSize {
        let width = (UIScreen.main.bounds.width * 0.5) - 48
        let sourceTextSize = sourceTextLabel.calculateLabelHeight(with: width)
        let translatedTextSize = translatedTextLabel.calculateLabelHeight(with: width)
        if sourceTextSize.height > translatedTextSize.height {
            return CGSize(width: sourceTextSize.width - 32, height: sourceTextSize.height + 16) // Removed 32 from width because of the leading and trailing anchor, and added 16 becasue of top anchor multiplier 2
        }
        return CGSize(width: translatedTextSize.width - 32, height: translatedTextSize.height + 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        addBasicShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(sourceTextLabel)
        contentView.addSubview(dividerView)
        contentView.addSubview(translatedTextLabel)
        contentView.layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            dividerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dividerView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: dividerView.bottomAnchor, multiplier: 1),
            dividerView.widthAnchor.constraint(equalToConstant: 2),
            
            sourceTextLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            sourceTextLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            dividerView.trailingAnchor.constraint(equalToSystemSpacingAfter: sourceTextLabel.trailingAnchor, multiplier: 1),
            
            translatedTextLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            translatedTextLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: dividerView.trailingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: translatedTextLabel.trailingAnchor, multiplier: 2),
        ])
    }
    
    public func configure(languagePair: TMLanguagePair) {
        sourceTextLabel.text = languagePair.sourceText
        translatedTextLabel.text = languagePair.targetText
    }
    
    // MARK: - Selectors
    
}

