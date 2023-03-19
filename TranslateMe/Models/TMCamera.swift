//
//  TMCamera.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import AVFoundation
import UIKit

struct TMCamera {
    public func checkPermissions(completion: @escaping(Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case true:
                    completion(true)
                case false:
                    completion(false)
                }
            }
        }
    }

    public func handlePermissionFailed() -> UIAlertController {
        let ac = UIAlertController(title: "The app must have access to the camera to use the camera translating feature.",
                                   message: "Please consider updating your settings.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Open settings", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        })
        ac.addAction(UIAlertAction(title: "Close", style: .cancel))
        return ac
    }
}


