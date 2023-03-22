//
//  ConversationViewViewModel.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 20..
//

import Foundation
import MLKitTranslate

final class ConversationViewViewModel: TranslateViewModel {
    var conversations: [TXLanguagePair] = []
    
    let speechRecognizer = TXSpeechRecognizer()
    
    public let sourceSpeechNotificationName = "sourceConversationTranscription"
    public let targetSpeechNotificationName = "targetConversationTranscription"
    
    public func stopSpeechRecognizerListening() {
        if speechRecognizer.isListening {
            speechRecognizer.stopListening()
            guard let lastConversation = conversations.last else { return }
            if lastConversation.sourceText == "" || lastConversation.targetText == "" {
                conversations.removeLast()
            }
        }
    }
    
    public func startSpeechListening(notificationName: String, toLanguage: TranslateLanguage) throws {
        if !speechRecognizer.isListening {
            do {
                try speechRecognizer.startListening(language: toLanguage, notificationName: notificationName)
                conversations.append(TXLanguagePair(sourceLanguage: languagePair.sourceLanguage, targetLanguage: languagePair.targetLanguage))
            } catch let error {
                throw error
            }
        }
    }
    
    public func switchLanguages() {
        languagePair.switchLanguages()
        switchConversations()
        stopSpeechRecognizerListening()
    }
    
    private func switchConversations() {
        for conversation in conversations {
            conversation.switchLanguages()
        }
    }
}
