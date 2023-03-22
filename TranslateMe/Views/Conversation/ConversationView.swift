//
//  ConversationView.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 20..
//

import Foundation
import UIKit

protocol ConversationViewDelegate: AnyObject {
    func showPickerViewAlert(pickerView: UIPickerView, alert: UIAlertController)
    func handleShowErrorAlert(title: String, message: String)
}

class ConversationView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ConversationViewDelegate?
    
    private var viewModel: ConversationViewViewModel
    
    private let translateBetweenTwoLanguageSelectorView = TranslateBetweenTwoLanguageSelectorView()
    
    private let toolbarView = CameraToolbarView(toolBarButtonTypes: [.leftSpeech, .reset, .rightSpeech])
    
    private let languagePickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: .zero)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private let conversationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ConversationCollectionViewCell.self, forCellWithReuseIdentifier: ConversationCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: ConversationViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        translateBetweenTwoLanguageSelectorView.delegate = self
        languagePickerView.delegate = self
        conversationCollectionView.delegate = self
        conversationCollectionView.dataSource = self
        toolbarView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(sourceTranscriptionChanged), name: Notification.Name(viewModel.sourceSpeechNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(targetTranscriptionChanged), name: Notification.Name(viewModel.targetSpeechNotificationName), object: nil)
        configureUI()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        addSubview(toolbarView)
        addSubview(conversationCollectionView)
        addSubview(translateBetweenTwoLanguageSelectorView)
        
        NSLayoutConstraint.activate([
            translateBetweenTwoLanguageSelectorView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            translateBetweenTwoLanguageSelectorView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: translateBetweenTwoLanguageSelectorView.trailingAnchor, multiplier: 2),
            
            toolbarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbarView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            conversationCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            conversationCollectionView.topAnchor.constraint(equalTo: topAnchor),
            conversationCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            conversationCollectionView.bottomAnchor.constraint(equalTo: toolbarView.topAnchor),
        ])
    }
    
    private func configureViews() {
        let languagePair = viewModel.languagePair
        self.translateBetweenTwoLanguageSelectorView.configure(sourceLanguageString: languagePair.sourceLanguageString, targetLanguageString: languagePair.targetLanguageString)
    }
    
    private func scrollToBottomOfCollectionView() {
        let lastItemIndex = conversationCollectionView.numberOfItems(inSection: 0) - 1
        let lastItemIndexPath = IndexPath(item: lastItemIndex, section: 0)
        conversationCollectionView.scrollToItem(at: lastItemIndexPath, at: .top, animated: true)
    }

    // MARK: - Selectors
    
    @objc private func sourceTranscriptionChanged() {
        guard let lastConversation = viewModel.conversations.last else { return }
        lastConversation.sourceText = viewModel.speechRecognizer.transcription ?? ""
        lastConversation.translate(from: lastConversation.sourceLanguage, to: lastConversation.targetLanguage, translateFromTarget: false) { [weak self] in
            self?.conversationCollectionView.reloadData()
            self?.scrollToBottomOfCollectionView()
        }
    }
    
    @objc private func targetTranscriptionChanged() {
        guard let lastConversation = viewModel.conversations.last else { return }
        lastConversation.targetText = viewModel.speechRecognizer.transcription ?? ""
        lastConversation.translate(from: lastConversation.sourceLanguage, to: lastConversation.targetLanguage, translateFromTarget: true) { [weak self] in
            self?.conversationCollectionView.reloadData()
            self?.scrollToBottomOfCollectionView()
        }
    }
}

extension ConversationView: CameraToolbarViewDelegate {
    func didPressToolbarButton(button: CameraToolbarButton) {
        viewModel.stopSpeechRecognizerListening()
        
        switch button.toolbarType {
        case .leftSpeech where button.isSelected, .rightSpeech where button.isSelected:
            do {
                let notificationName = button.toolbarType == .leftSpeech ? viewModel.sourceSpeechNotificationName : viewModel.targetSpeechNotificationName
                let language = button.toolbarType == .leftSpeech ? viewModel.languagePair.sourceLanguage : viewModel.languagePair.targetLanguage
                try viewModel.startSpeechListening(notificationName: notificationName, toLanguage: language)
            } catch {
                delegate?.handleShowErrorAlert(title: "Error", message: "There was an error starting speech recognition.")
            }
        case .reset:
            viewModel.conversations = []
        default:
            break
        }

        conversationCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ConversationView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: translateBetweenTwoLanguageSelectorView.intrinsicContentSize.height + 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = ConversationCollectionViewCell()
        cell.configure(languagePair: viewModel.conversations[indexPath.row])
        let size = cell.intrinsicContentSize
        return size
    }
}

// MARK: - UICollectionViewDataSource

extension ConversationView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.conversations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConversationCollectionViewCell.reuseIdentifier, for: indexPath) as? ConversationCollectionViewCell else {
            fatalError()
        }
        
        cell.configure(languagePair: viewModel.conversations[indexPath.row])
        return cell
    }
    
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension ConversationView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TMLanguageModels.shared.localModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TMLanguages.shared.createLanguageStringWithTranslateLanguage(from: TMLanguageModels.shared.localModels[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 10
    }
}

// MARK: - TranslateBetweenTwoLanguageSelectorViewDelegate

extension ConversationView: TranslateBetweenTwoLanguageSelectorViewDelegate {
    func didPressSelectLanguage(languageLabel: MainLanguageNameLabelView) {
        languagePickerView.reloadAllComponents()
        let alert = UIAlertController(title: "Downloaded Languages", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            let selectedIndex = strongSelf.languagePickerView.selectedRow(inComponent: 0)
            let selectedLanguage = TMLanguageModels.shared.localModels[selectedIndex]
            let selectedLanguageString = TMLanguages.shared.createLanguageStringWithTranslateLanguage(from: selectedLanguage)
            
            languageLabel.configure(withLanguage: selectedLanguageString)
            
            if languageLabel.source {
                strongSelf.viewModel.languagePair.sourceLanguage = selectedLanguage
                let viewModelPair = strongSelf.viewModel.languagePair
                for languagePair in strongSelf.viewModel.conversations {
                    languagePair.targetLanguage = viewModelPair.targetLanguage
                    languagePair.sourceLanguage = viewModelPair.sourceLanguage
                    languagePair.translate(from: viewModelPair.sourceLanguage, to: viewModelPair.targetLanguage, translateFromTarget: true) {
                        strongSelf.conversationCollectionView.reloadData()
                        strongSelf.scrollToBottomOfCollectionView()
                    }
                }
            } else {
                strongSelf.viewModel.languagePair.targetLanguage = selectedLanguage
                let viewModelPair = strongSelf.viewModel.languagePair
                for languagePair in strongSelf.viewModel.conversations {
                    languagePair.targetLanguage = viewModelPair.targetLanguage
                    languagePair.sourceLanguage = viewModelPair.sourceLanguage
                    languagePair.translate(from: viewModelPair.sourceLanguage, to: viewModelPair.targetLanguage, translateFromTarget: false) {
                        strongSelf.conversationCollectionView.reloadData()
                        strongSelf.scrollToBottomOfCollectionView()
                    }
                }
                
            }
            
            strongSelf.configureViews()
        }))
        delegate?.showPickerViewAlert(pickerView: self.languagePickerView, alert: alert)
    }
    
    func didPressSwitchLanguagesButton() {
        viewModel.switchLanguages()
        configureViews()
        conversationCollectionView.reloadData()
    }
}
