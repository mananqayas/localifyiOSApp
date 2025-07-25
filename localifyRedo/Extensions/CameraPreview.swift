//
//  CameraPreview.swift
//  localifyRedo
//
//  Created by Manan Qayas on 14/06/2025.
//

import Foundation
import AVFoundation
import SwiftUI

@MainActor
class CameraManager: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    private let session =  AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    @Published var isSessionRunning = false
    @Published var capturedImage: UIImage?
    
    override init() {
        super.init()
        configureSession()
        
    }
    
    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try?  AVCaptureDeviceInput(device: camera),
              session.canAddInput(input) else {
            print("Cannot access camera")
            return
        }
        session.addInput(input)
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        session.commitConfiguration()
    }
    
    func startSession() {
        if !session.isRunning {
            session.startRunning()
            isSessionRunning = true
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
            isSessionRunning = false
        }
    }
    func capturePhoto() {
        
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation() {
            capturedImage = UIImage(data: data)
            stopSession()
        }
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
        if previewLayer == nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = .resizeAspectFill
        }
        
        return previewLayer!
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraManager: CameraManager
    
    func makeUIView(context: Context)->UIView {
        let view = UIView()
        let previewLayer = cameraManager.getPreviewLayer()
        previewLayer.frame = view.bounds
        previewLayer.connection?.videoOrientation = .portrait
        view.layer.addSublayer(previewLayer)
        DispatchQueue.main.async {
            previewLayer.frame = view.bounds
        }
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
 
    
    
    
}
