//
//  CameraView.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//
import SwiftUI
import AVFoundation
import PhotosUI

// MARK: - Media Type
enum MediaType: String, CaseIterable {
    case post = "Post"
    case photo = "Photo"
    case video = "Video"
    case goal = "Goal"
    
    var icon: String {
        switch self {
        case .post: return "square.and.pencil"
        case .photo: return "camera.fill"
        case .video: return "video.fill"
        case .goal: return "target"
        }
    }
    
    var description: String {
        switch self {
        case .post: return "Sosyal medya için fotoğraf çek"
        case .photo: return "Standart fotoğraf çek"
        case .video: return "Video kaydet"
        case .goal: return "Hedef fotoğrafı çek"
        }
    }
}

// MARK: - Camera View
struct CameraView: View {
    @StateObject private var cameraViewModel = CameraViewModel()
    @State private var selectedTab: MediaType = .photo
    @State private var showPhotoLibrary = false
    @State private var showCapturedMedia = false
    @State private var flashMode: AVCaptureDevice.FlashMode = .off
    @State private var showSettings = false
    
    var body: some View {
        GeometryReader { geoProxy in
            NavigationStack {
                VStack(spacing: 0) {
                    // Camera Preview Section
                    ZStack {
                        CameraPreviewSection(
                            cameraViewModel: cameraViewModel,
                            flashMode: $flashMode,
                            selectedTab: selectedTab
                        )
                        
                        // Top Controls Overlay
                        VStack {
                            TopControlsBar(
                                flashMode: $flashMode,
                                onSettingsTap: { showSettings = true },
                                onFlashTap: { toggleFlash() }
                            )
                            .padding()
                            
                            Spacer()
                        }
                    }
                    .frame(height: geoProxy.size.height * 0.70)
                    
                    // Controls Section
                    ControlsSection(
                        cameraViewModel: cameraViewModel,
                        selectedTab: selectedTab,
                        onGalleryTap: { showPhotoLibrary = true },
                        onCapture: { handleCapture() },
                        onSwitchCamera: { cameraViewModel.switchCamera() }
                    )
                    .frame(height: geoProxy.size.height * 0.15)
                    .background(Color.black)
                    
                    // Mode Description
                    ModeDescriptionSection(selectedTab: selectedTab)
                        .frame(height: geoProxy.size.height * 0.05)
                        .background(Color.black.opacity(0.9))
                    
                    // Mode Selector
                    ModeSelectorSection(
                        selectedTab: $selectedTab,
                        onTabChange: { newTab in
                            handleTabChange(newTab)
                        }
                    )
                    .frame(height: geoProxy.size.height * 0.10)
                    .background(Color.black.opacity(0.95))
                }
                .background(Color.black)
            }
        }
        .onAppear {
            cameraViewModel.checkCameraPermission()
        }
        .sheet(isPresented: $showPhotoLibrary) {
            PhotoLibraryView()
        }
        .sheet(isPresented: $showSettings) {
            CameraSettingsView(cameraViewModel: cameraViewModel)
        }
    }
    
    private func handleCapture() {
        switch selectedTab {
        case .photo, .post, .goal:
            cameraViewModel.capturePhoto()
            showCapturedMedia = true
        case .video:
            cameraViewModel.toggleVideoRecording()
        }
    }
    
    private func handleTabChange(_ newTab: MediaType) {
        selectedTab = newTab
        if newTab == .video {
            cameraViewModel.switchToVideoMode()
        } else {
            cameraViewModel.switchToPhotoMode()
        }
    }
    
    private func toggleFlash() {
        switch flashMode {
        case .off:
            flashMode = .on
        case .on:
            flashMode = .auto
        case .auto:
            flashMode = .off
        @unknown default:
            flashMode = .off
        }
//        $cameraVie wModel.(flashMode)
    }
}

// MARK: - Camera Preview Section
struct CameraPreviewSection: View {
    @ObservedObject var cameraViewModel: CameraViewModel
    @Binding var flashMode: AVCaptureDevice.FlashMode
    let selectedTab: MediaType
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            Group {
                switch cameraViewModel.cameraAuthStatus {
                case .notDetermined:
                    PermissionRequestView(
                        icon: "camera.fill",
                        title: "Kameraya Erişim",
                        message: "Fotoğraf ve video çekmek için kamera iznine ihtiyacımız var",
                        buttonTitle: "İzin Ver",
                        action: { cameraViewModel.requestCameraPermission() }
                    )
                    
                case .denied, .restricted:
                    PermissionRequestView(
                        icon: "exclamationmark.triangle.fill",
                        title: "Kamera Erişimi Reddedildi",
                        message: "Kameraya erişim için lütfen Ayarlar'dan izin verin",
                        buttonTitle: "Ayarları Aç",
                        iconColor: .orange,
                        action: {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                    
                case .authorized:
                    CameraPreviewView(session: cameraViewModel.captureSession)
                        .onAppear {
                            cameraViewModel.setupCamera()
                        }
                        .onDisappear {
                            cameraViewModel.stopSession()
                        }
                        .overlay(
                            GridOverlay(isVisible: selectedTab == .post || selectedTab == .goal)
                        )
                    
                @unknown default:
                    EmptyView()
                }
            }
            
            // Recording Indicator
            if cameraViewModel.isRecording {
                VStack {
                    RecordingIndicator(recordingTime: cameraViewModel.recordingTime)
                        .padding(.top, 60)
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Permission Request View
struct PermissionRequestView: View {
    let icon: String
    let title: String
    let message: String
    let buttonTitle: String
    var iconColor: Color = .white
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(iconColor)
            
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(buttonTitle) {
                action()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

// MARK: - Top Controls Bar
struct TopControlsBar: View {
    @Binding var flashMode: AVCaptureDevice.FlashMode
    let onSettingsTap: () -> Void
    let onFlashTap: () -> Void
    
    var flashIcon: String {
        switch flashMode {
        case .off: return "bolt.slash.fill"
        case .on: return "bolt.fill"
        case .auto: return "bolt.badge.automatic.fill"
        @unknown default: return "bolt.slash.fill"
        }
    }
    
    var body: some View {
        HStack {
            Button(action: onFlashTap) {
                Image(systemName: flashIcon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Button(action: onSettingsTap) {
                Image(systemName: "gearshape.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
        }
    }
}

// MARK: - Grid Overlay
struct GridOverlay: View {
    let isVisible: Bool
    
    var body: some View {
        if isVisible {
            GeometryReader { geometry in
                Path { path in
                    // Vertical lines
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    path.move(to: CGPoint(x: width / 3, y: 0))
                    path.addLine(to: CGPoint(x: width / 3, y: height))
                    
                    path.move(to: CGPoint(x: 2 * width / 3, y: 0))
                    path.addLine(to: CGPoint(x: 2 * width / 3, y: height))
                    
                    // Horizontal lines
                    path.move(to: CGPoint(x: 0, y: height / 3))
                    path.addLine(to: CGPoint(x: width, y: height / 3))
                    
                    path.move(to: CGPoint(x: 0, y: 2 * height / 3))
                    path.addLine(to: CGPoint(x: width, y: 2 * height / 3))
                }
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
            }
        }
    }
}

// MARK: - Recording Indicator
struct RecordingIndicator: View {
    let recordingTime: String
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.red)
                .frame(width: 10, height: 10)
                .opacity(isAnimating ? 1 : 0.3)
                .animation(
                    Animation.easeInOut(duration: 1).repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            Text(recordingTime)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.6))
        .cornerRadius(20)
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Controls Section
struct ControlsSection: View {
    @ObservedObject var cameraViewModel: CameraViewModel
    let selectedTab: MediaType
    let onGalleryTap: () -> Void
    let onCapture: () -> Void
    let onSwitchCamera: () -> Void
    
    var body: some View {
        HStack(spacing: 50) {
            // Gallery Button
            Button(action: onGalleryTap) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
            }
            
            // Capture Button
            Button(action: onCapture) {
                ZStack {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 4)
                        .frame(width: 70, height: 70)
                    
                    if selectedTab == .video && cameraViewModel.isRecording {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red)
                            .frame(width: 30, height: 30)
                    } else {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                    }
                }
            }
            
            // Switch Camera Button
            Button(action: onSwitchCamera) {
                Image(systemName: "camera.rotate.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
            }
        }
    }
}

// MARK: - Mode Description Section
struct ModeDescriptionSection: View {
    let selectedTab: MediaType
    
    var body: some View {
        HStack {
            Spacer()
            Text(selectedTab.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            Spacer()
        }
    }
}

// MARK: - Mode Selector Section
struct ModeSelectorSection: View {
    @Binding var selectedTab: MediaType
    let onTabChange: (MediaType) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(MediaType.allCases, id: \.self) { mode in
                    ModeButton(
                        mode: mode,
                        isSelected: selectedTab == mode,
                        action: {
                            selectedTab = mode
                            onTabChange(mode)
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Mode Button
struct ModeButton: View {
    let mode: MediaType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: mode.icon)
                    .font(.caption)
                
                Text(mode.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .foregroundColor(isSelected ? .black : .white)
            .background(isSelected ? Color.white : Color.white.opacity(0.2))
            .clipShape(Capsule())
        }
    }
}

// MARK: - Photo Library View
struct PhotoLibraryView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 2) {
                    ForEach(0..<20) { index in
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundColor(.gray)
                            )
                    }
                }
            }
            .navigationTitle("Galeri")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Camera Settings View
struct CameraSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var cameraViewModel: CameraViewModel
    @State private var gridEnabled = false
    @State private var soundEnabled = true
    @State private var selectedQuality = "High"
    
    let qualities = ["Low", "Medium", "High", "4K"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Genel Ayarlar") {
                    Toggle("Izgara Göster", isOn: $gridEnabled)
                    Toggle("Ses Efektleri", isOn: $soundEnabled)
                }
                
                Section("Video Kalitesi") {
                    Picker("Kalite", selection: $selectedQuality) {
                        ForEach(qualities, id: \.self) { quality in
                            Text(quality).tag(quality)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Hakkında") {
                    HStack {
                        Text("Versiyon")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    CameraView()
}
