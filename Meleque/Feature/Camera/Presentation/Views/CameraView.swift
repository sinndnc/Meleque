//
//  CameraView.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//
import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @StateObject private var vm = CameraViewModel()
    @State private var selectedTab: MediaType = .photo
    
    enum MediaType {
        case photo, video, post, goal
    }
    
    var body: some View {
        GeometryReader { geoProxy in
            NavigationStack{
                VStack{
                    ZStack {
                        Color.black.edgesIgnoringSafeArea(.all)
                        Group {
                            switch vm.cameraAuthStatus {
                            case .notDetermined:
                                VStack(spacing: 20) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white)
                                    
                                    Text("Kameraya Erişim")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                    
                                    Text("Fotoğraf ve video çekmek için kamera iznine ihtiyacımız var")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    
                                    Button("İzin Ver") {
                                        vm.requestCameraPermission()
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .controlSize(.large)
                                }
                                .padding()
                                
                            case .denied, .restricted:
                                VStack(spacing: 20) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.orange)
                                    
                                    Text("Kamera Erişimi Reddedildi")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                    
                                    Text("Kameraya erişim için lütfen Ayarlar'dan izin verin")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    
                                    Button("Ayarları Aç") {
                                        if let url = URL(string: UIApplication.openSettingsURLString) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                                .padding()
                                
                            case .authorized:
                                CameraPreviewView(session: vm.captureSession)
                                    .onAppear {
                                        vm.setupCamera()
                                    }
                                    .onDisappear {
                                        vm.stopSession()
                                    }
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    .frame(
                        width: geoProxy.size.width,
                        height: geoProxy.size.height * 0.75
                    )
                    
                    VStack{
                        HStack(spacing: 50) {
                            // Galeri butonu
                            Button(action: {
                                // Galeri açma işlemi
                            }) {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                            
                            // Ana çekim butonu
                            Button(action: {
                                if selectedTab == .photo {
                                    vm.capturePhoto()
                                } else {
                                    vm.toggleVideoRecording()
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .strokeBorder(Color.white, lineWidth: 4)
                                        .frame(width: 60, height: 60)
                                    
                                    Circle()
                                        .fill(vm.isRecording ? Color.red : Color.white)
                                        .frame(width: vm.isRecording ? 30 : 50, height: vm.isRecording ? 30 : 50)
                                        .cornerRadius(vm.isRecording ? 5 : 30)
                                }
                            }
                            
                            // Kamera değiştir butonu
                            Button(action: {
                                vm.switchCamera()
                            }) {
                                Image(systemName: "camera.rotate")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.vertical, 10)
                        
                        // Kayıt süresi göstergesi (video modunda)
                        if selectedTab == .video && vm.isRecording {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                
                                Text(vm.recordingTime)
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 20)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(20)
                        }
                        
                        HStack{
                            Text("Buraya metin girilecek yer")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                    .frame(
                        width: geoProxy.size.width,
                        height: geoProxy.size.height * 0.15
                    )
                    VStack{
                        HStack{
                            Spacer()
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack{
                                    Button(action: {
                                        selectedTab = .post
                                        vm.switchToPhotoMode()
                                    }) {
                                        Text("Post")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .padding(.vertical,10)
                                            .padding(.horizontal,5)
                                            .frame(width: geoProxy.size.width * 0.25)
                                            .foregroundColor(selectedTab == .post ? .black : .white)
                                            .background(selectedTab == .post ? Color.white : Color.clear)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                    }
                                    Button(action: {
                                        selectedTab = .photo
                                        vm.switchToPhotoMode()
                                    }) {
                                        Text("Photo")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .padding(.vertical,10)
                                            .padding(.horizontal,5)
                                            .frame(width: geoProxy.size.width * 0.25)
                                            .foregroundColor(selectedTab == .photo ? .black : .white)
                                            .background(selectedTab == .photo ? Color.white : Color.clear)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                    }
                                    Button(action: {
                                        selectedTab = .video
                                        vm.switchToPhotoMode()
                                    }) {
                                        Text("Video")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .padding(.vertical,10)
                                            .padding(.horizontal,5)
                                            .frame(width: geoProxy.size.width * 0.25)
                                            .foregroundColor(selectedTab == .video ? .black : .white)
                                            .background(selectedTab == .video ? Color.white : Color.clear)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                    }
                                    Button(action: {
                                        selectedTab = .goal
                                        vm.switchToPhotoMode()
                                    }) {
                                        Text("Goal")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .padding(.vertical,10)
                                            .padding(.horizontal,5)
                                            .frame(width: geoProxy.size.width * 0.25)
                                            .foregroundColor(selectedTab == .goal ? .black : .white)
                                            .background(selectedTab == .goal ? Color.white : Color.clear)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                    }
                                }
                            }
                            .frame(width: geoProxy.size.width * 0.75)
                            .background(.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            Spacer()
                        }
                    }
                    .frame(
                        width: geoProxy.size.width,
                        height: geoProxy.size.height * 0.1
                    )
                }
                .frame(
                    width: geoProxy.size.width,
                    height: geoProxy.size.height
                )
            }
        }
        .onAppear {
            vm.checkCameraPermission()
        }
    }
}

#Preview {
    CameraView()
}
