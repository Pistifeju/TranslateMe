//
//  TranslateTextTextView.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 14..
//

import Foundation
import UIKit

protocol TranslateTextTextViewDelegate: AnyObject {
    func textViewDidChange(sourceTextViewString: String)
    func didTapVoiceButton(sourceTextViewString: String, sourceTextView: Bool)
}

class TranslateTextTextView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: TranslateTextTextViewDelegate?
        
    private let sourceTextView: Bool
    
    private let translateOrderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.text = "English"
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let translateTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .secondaryLabel
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .systemBackground
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    private let textViewWrapperUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBasicShadow()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let voiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
        return button
    }()
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        let height = textViewWrapperUIView.bounds.height + languageLabel.bounds.height + 8 // Added +8 because of the anchor multiplier between the textView and labels
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    // MARK: - Lifecycle
    
    init(translateOrderLabel: String, allowEditingTextView: Bool = true) {
        self.translateOrderLabel.text = translateOrderLabel
        self.sourceTextView = allowEditingTextView
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        translateTextView.isUserInteractionEnabled = allowEditingTextView
        translateTextView.delegate = self
        voiceButton.addTarget(self, action: #selector(didTapVoiceButton), for: .touchUpInside)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        addSubview(translateOrderLabel)
        addSubview(languageLabel)
        addSubview(textViewWrapperUIView)
        addSubview(translateTextView)
        addSubview(voiceButton)
        
        NSLayoutConstraint.activate([
            translateOrderLabel.topAnchor.constraint(equalTo: topAnchor),
            translateOrderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            languageLabel.topAnchor.constraint(equalTo: topAnchor),
            languageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            translateTextView.topAnchor.constraint(equalToSystemSpacingBelow: translateOrderLabel.bottomAnchor, multiplier: 1),
            translateTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            translateTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            translateTextView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*0.2),
            
            trailingAnchor.constraint(equalToSystemSpacingAfter: voiceButton.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: voiceButton.bottomAnchor, multiplier: 2),
            
            textViewWrapperUIView.topAnchor.constraint(equalToSystemSpacingBelow: translateOrderLabel.bottomAnchor, multiplier: 1),
            textViewWrapperUIView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textViewWrapperUIView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textViewWrapperUIView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*0.2),
        ])
        
        layoutIfNeeded()
        translateTextView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: voiceButton.frame.height + 8, right: 5)
    }
    
    public func configure(languageString: String?, textViewString: String?) {
        if let languageString {
            languageLabel.text = languageString
        }
        if let textViewString {
            translateTextView.text = textViewString
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didTapVoiceButton() {
        delegate?.didTapVoiceButton(sourceTextViewString: translateTextView.text, sourceTextView: sourceTextView)
    }
}

extension TranslateTextTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(sourceTextViewString: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidChange(sourceTextViewString: textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidChange(sourceTextViewString: textView.text)
    }
}
