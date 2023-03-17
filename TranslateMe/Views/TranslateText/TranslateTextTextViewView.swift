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
    func didTapSpeakButton(textView: UITextView, recording: Bool, ac: UIAlertController?)
    func didTapIdentifiedLanguage(languageCode: String)
}

class TranslateTextTextView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: TranslateTextTextViewDelegate?
    
    private let sourceTextView: Bool
    
    private var languageCode: String?
    
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
    
    private let identifiedLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "English"
        label.textColor = .systemYellow.withAlphaComponent(0.5)
        label.backgroundColor = .systemBackground
        label.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.alpha = 0
        label.isUserInteractionEnabled = true
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
    
    private lazy var speakButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "mic.slash.circle"), for: .normal)
        button.setImage(UIImage(systemName: "mic.circle"), for: .selected)
        button.setTitleColor(UIColor.clear, for: .selected)
        button.isHidden = !sourceTextView
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
        speakButton.addTarget(self, action: #selector(didTapSpeakButton), for: .touchUpInside)
        voiceButton.addTarget(self, action: #selector(didTapVoiceButton), for: .touchUpInside)
        identifiedLanguageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapIdentifiedLanguage)))
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
        addSubview(speakButton)
        addSubview(identifiedLanguageLabel)
        
        NSLayoutConstraint.activate([
            translateOrderLabel.topAnchor.constraint(equalTo: topAnchor),
            translateOrderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            languageLabel.topAnchor.constraint(equalTo: topAnchor),
            languageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            identifiedLanguageLabel.topAnchor.constraint(equalTo: topAnchor),
            languageLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: identifiedLanguageLabel.trailingAnchor, multiplier: 1),
            
            translateTextView.topAnchor.constraint(equalToSystemSpacingBelow: translateOrderLabel.bottomAnchor, multiplier: 1),
            translateTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            translateTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            translateTextView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*0.2),
            
            trailingAnchor.constraint(equalToSystemSpacingAfter: voiceButton.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: voiceButton.bottomAnchor, multiplier: 2),
            speakButton.centerYAnchor.constraint(equalTo: voiceButton.centerYAnchor),
            voiceButton.leadingAnchor.constraint(equalToSystemSpacingAfter: speakButton.trailingAnchor, multiplier: 2),
            
            textViewWrapperUIView.topAnchor.constraint(equalToSystemSpacingBelow: translateOrderLabel.bottomAnchor, multiplier: 1),
            textViewWrapperUIView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textViewWrapperUIView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textViewWrapperUIView.heightAnchor.constraint(equalTo: translateTextView.heightAnchor),
        ])
        
        layoutIfNeeded()
        translateTextView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: voiceButton.frame.height + 12, right: 5)
    }
    
    public func configure(languageString: String, textViewString: String?, speakButtonIsSelected: Bool) {
        languageLabel.text = languageString
        speakButton.isSelected = speakButtonIsSelected
        if let textViewString {
            translateTextView.text = textViewString
        }
    }
    
    public func showIdentifiedLanguageLabel(with languageCode: String) {
        self.languageCode = languageCode
        let language = TMLanguages.shared.createLanguageStringWithLanguageCode(from: languageCode)
        if language != languageLabel.text {
            identifiedLanguageLabel.text = language + "?"
            identifiedLanguageLabel.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.identifiedLanguageLabel.alpha = 1
            }
        }
    }
    
    public func hideIdentifiedLanguageLabel() {
        UIView.animate(withDuration: 0.3, animations: {
            self.identifiedLanguageLabel.alpha = 0
        }) { (complete) in
            self.identifiedLanguageLabel.isHidden = true
            self.identifiedLanguageLabel.text = ""
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didTapVoiceButton() {
        delegate?.didTapVoiceButton(sourceTextViewString: translateTextView.text, sourceTextView: sourceTextView)
    }
    
    @objc private func didTapSpeakButton() {
        let speechRecognizer = TMSpeechRecognizer()
        speechRecognizer.checkPermissions { [weak self] success in
            guard let strongSelf = self else { return }
            switch success {
            case true:
                strongSelf.speakButton.isSelected.toggle()
                strongSelf.delegate?.didTapSpeakButton(textView: strongSelf.translateTextView, recording: strongSelf.speakButton.isSelected, ac: nil)
            case false:
                let ac = speechRecognizer.handlePermissionFailed()
                strongSelf.delegate?.didTapSpeakButton(textView: strongSelf.translateTextView, recording: strongSelf.speakButton.isSelected, ac: ac)
            }
        }
    }
    
    @objc private func didTapIdentifiedLanguage() {
        delegate?.didTapIdentifiedLanguage(languageCode: languageCode ?? "")
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
