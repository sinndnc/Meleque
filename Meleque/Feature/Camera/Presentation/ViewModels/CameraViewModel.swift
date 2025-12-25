//
//  CameraViewModel.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//
import Combine
import Foundation
import AVFoundation
import Photos

class CameraViewModel: NSObject, ObservableObject {
    @Published var cameraAuthStatus: AVAuthorizationStatus = .notDetermined
    @Published var isRecording = false
    @Published var recordingTime = "00:00"
    
    let captureSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var movieOutput = AVCaptureMovieFileOutput()
    private var currentCamera: AVCaptureDevice?
    private var currentInput: AVCaptureDeviceInput?
    private var recordingTimer: Timer?
    private var recordingSeconds = 0
    
    func checkCameraPermission() {
        cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.cameraAuthStatus = granted ? .authorized : .denied
            }
        }
    }
    
    func setupCamera() {
        captureSession.beginConfiguration()
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                currentInput = input
                currentCamera = camera
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            if captureSession.canAddOutput(movieOutput) {
                captureSession.addOutput(movieOutput)
            }
            
            captureSession.commitConfiguration()
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.startRunning()
            }
        } catch {
            print("Kamera hatası: \(error.localizedDescription)")
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func switchToPhotoMode() {
        // Fotoğraf moduna geç
    }
    
    func switchToVideoMode() {
        // Video moduna geç
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func toggleVideoRecording() {
        if isRecording {
            stopVideoRecording()
        } else {
            startVideoRecording()
        }
    }
    
    private func startVideoRecording() {
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mov")
        
        movieOutput.startRecording(to: tempURL, recordingDelegate: self)
        isRecording = true
        recordingSeconds = 0
        
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordingSeconds += 1
            let minutes = self.recordingSeconds / 60
            let seconds = self.recordingSeconds % 60
            self.recordingTime = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private func stopVideoRecording() {
        movieOutput.stopRecording()
        isRecording = false
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
    
    func switchCamera() {
        captureSession.beginConfiguration()
        
        if let currentInput = currentInput {
            captureSession.removeInput(currentInput)
        }
        
        let newPosition: AVCaptureDevice.Position = currentCamera?.position == .back ? .front : .back
        
        guard let newCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else {
            captureSession.commitConfiguration()
            return
        }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: newCamera)
            if captureSession.canAddInput(newInput) {
                captureSession.addInput(newInput)
                currentInput = newInput
                currentCamera = newCamera
            }
        } catch {
            print("Kamera değiştirme hatası: \(error.localizedDescription)")
        }
        
        captureSession.commitConfiguration()
    }
    
    private func saveToLibrary(imageData: Data) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: imageData, options: nil)
            })
        }
    }
    
    private func saveVideoToLibrary(_ url: URL) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            })
        }
    }
}

// MARK: - Photo Capture Delegate
extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        saveToLibrary(imageData: imageData)
    }
}

// MARK: - Video Recording Delegate
extension CameraViewModel: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            saveVideoToLibrary(outputFileURL)
        }
    }
}
