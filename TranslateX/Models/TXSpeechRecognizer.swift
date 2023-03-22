//
//  TXSpeechRecognizer.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 16..
//

import Foundation
import AVFoundation
import Speech
import MLKitTranslate
import UIKit

final class TXSpeechRecognizer {
    var isListening = false
    var transcription: String?
    
    private var speechRecognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    // MARK: - Speech
    
    func startListening(language: TranslateLanguage, notificationName: String) throws {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: language.createLanguageCode()))
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            throw NSError(domain: "com.example.speechrecognition", code: 1, userInfo: nil)
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: [])
        try audioSession.setActive(true, options: [])
        inputNode = audioEngine.inputNode
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw NSError(domain: "com.example.speechrecognition", code: 2, userInfo: nil)
        }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] result, error in
            guard let result = result else {
                if let error = error {
                    return
                }
                return
            }
            
            self?.transcription = result.bestTranscription.formattedString
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil)
        }) 
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { buffer, time in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        isListening = true
    }
    
    func stopListening() {
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isListening = false
    }
}
