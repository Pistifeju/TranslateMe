//
//  TXSupportEmail.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 18..
//

import UIKit
import Foundation
import SwiftUI

struct TXSupportEmail {
    let toAdress: String
    let subject: String
    let messageHeader: String
    var body: String {"""
        Application Name: \(Bundle.main.displayName)
        iOS: \(UIDevice.current.systemVersion)
        Device Model: \(UIDevice.current.modelName)
        App Version: \(Bundle.main.appVersion)
        App Build: \(Bundle.main.appBuild)
        \(messageHeader)
    -----------------------------------------
    """
    }
    
    func send(openURL: OpenURLAction) {
        let subject = subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let body = body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlString = "mailto:\(toAdress)?subject=\(subject)&body=\(body)"
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("""
                This device does not support email
                \(body)
                """)
            }
        }
    }
}
