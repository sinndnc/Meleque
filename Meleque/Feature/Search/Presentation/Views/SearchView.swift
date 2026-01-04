//
//  SearchView.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//
import SwiftUI
internal import Photos

struct SearchView: View {
    
    @State private var searchText : String = ""
    @EnvironmentObject private var cameraViewModel : CameraViewModel
    @EnvironmentObject private var photoGalleryViewModel : PhotoGalleryViewModel
    
    var body: some View {
        GeometryReader { geoProxy in
            NavigationStack{
                Group{
                    switch photoGalleryViewModel.authorizationStatus {
                    case .notDetermined:
                        VStack(spacing: 20) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("Fotoğraflara Erişim")
                                .font(.title2)
                                .bold()
                            
                            Text("Fotoğraflarınızı görmek için izin gerekiyor")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button("İzin Ver") {
                                photoGalleryViewModel.requestAuthorization()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        
                    case .denied, .restricted:
                        VStack(spacing: 20) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 60))
                                .foregroundColor(.orange)
                            
                            Text("Erişim Reddedildi")
                                .font(.title2)
                                .bold()
                            
                            Text("Fotoğraflara erişim için lütfen Ayarlar'dan izin verin")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button("Ayarları Aç") {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        
                    case .authorized, .limited:
                        if photoGalleryViewModel.photos.isEmpty {
                            VStack(spacing: 20) {
                                ProgressView()
                                Text("Fotoğraflar yükleniyor...")
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            ScrollView{
                                LazyVStack(spacing: 5){
                                    ForEach(photoGalleryViewModel.photos) { item in
                                        NavigationLink {
                                            PostDetailView(photo: item)
                                        } label: {
                                            HStack(alignment: .top, spacing: 12) {
                                                VStack(alignment: .leading, spacing: 12) {
                                                    // Fotoğraf
                                                    PhotoGridItem(asset: item.asset)
                                                        .aspectRatio(1, contentMode: .fill)
                                                        .frame(
                                                            maxWidth: geoProxy.size.width * 0.75,
                                                            maxHeight: geoProxy.size.height * 0.25
                                                        )
                                                        .background(Color.gray.opacity(0.1))
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                                    
                                                    // Açıklama metni
                                                    VStack(alignment: .leading, spacing: 4) {
                                                        Text("Fotoğraf Detayları")
                                                            .font(.subheadline)
                                                            .fontWeight(.semibold)
                                                            .foregroundStyle(.primary)
                                                        
                                                        Text("Buraya ne yazılacak okuyamadım ama böyle bir alan var")
                                                            .lineLimit(2)
                                                            .font(.caption)
                                                            .foregroundStyle(.secondary)
                                                            .multilineTextAlignment(.leading)
                                                    }
                                                    .padding(.horizontal, 8)
                                                }
                                                
                                                Spacer(minLength: 0)
                                                
                                                VStack(spacing: 16) {
                                                    actionButton(icon: "gear", color: .gray)
                                                    actionButton(icon: "heart", color: .red)
                                                    actionButton(icon: "archivebox", color: .blue)
                                                    actionButton(icon: "trash", color: .red)
                                                }
                                                .padding(.trailing, 8)
                                                .frame(
                                                    maxHeight: geoProxy.size.height * 0.25
                                                )
                                            }
                                            .padding(16)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color(.systemBackground))
                                                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                            )
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            
                                            // Helper function
                                            
                                        }
                                    }
                                }
                            }
                        }
                    @unknown default:
                        EmptyView()
                    }
                  
                }
                .searchable(text: $searchText, prompt: "Search something" )
                .navigationTitle("Search")
            }
        }
    }
    
    private func actionButton(icon: String, color: Color) -> some View {
        Button {
            // Action
        } label: {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.1))
                .clipShape(Circle())
        }
    }
}


#Preview {
    SearchView()
}
