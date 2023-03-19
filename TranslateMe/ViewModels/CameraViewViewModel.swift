//
//  CameraViewViewModel.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import JGProgressHUD
import AVFoundation

final class CameraViewViewModel: TranslateViewModel {
    public let isCameraEnabled = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    public var captureSession: AVCaptureSession!
    public var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    private var stillImageOutput: AVCapturePhotoOutput!
    
    public func toggleFlash() {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if (backCamera.hasTorch) {
            do {
                try backCamera.lockForConfiguration()
                if (backCamera.torchMode == AVCaptureDevice.TorchMode.on) {
                    backCamera.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    do {
                        try backCamera.setTorchModeOn(level: 1.0)
                    } catch {
                        print(error)
                        // TODO: - Show error alert here
                    }
                }
                backCamera.unlockForConfiguration()
            } catch {
                // TODO: - Show error alert here
            }
        }
    }
    
    public func setupCameraPreviewLayer(completion: @escaping(Error?) -> Void) {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupCameraLivePreview {
                    completion(nil)
                    return
                }
            }
        }
        catch let error  {
            completion(error)
        }
    }
    
    private func setupCameraLivePreview(completion: @escaping() -> Void) {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        completion()
        return
    }
    
    public func stopRunningCaptureSession() {
        guard captureSession != nil else { return }
        captureSession.stopRunning()
    }
    
    public func startRunningCaptureSession() {
        guard captureSession != nil, !captureSession.isRunning else { return }
        captureSession.startRunning()
    }
}
