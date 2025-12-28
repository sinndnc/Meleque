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
    @StateObject private var vm = PhotoGalleryViewModel()
    
    var body: some View {
        GeometryReader { geoProxy in
            NavigationStack{
                ZStack{
                    switch vm.authorizationStatus {
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
                                vm.requestAuthorization()
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
                        if vm.photos.isEmpty {
                            VStack(spacing: 20) {
                                ProgressView()
                                Text("Fotoğraflar yükleniyor...")
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            VStack {
                                ScrollView {
                                    ForEach(vm.photos) { item in
                                        postComponent(
                                            geoProxy: geoProxy,
                                            photo: item
                                        )
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
}

private func postComponent(geoProxy : GeometryProxy,photo: Photo) -> some View {
    
    HStack{
        VStack{
            ZStack{
                GeometryReader { geo in
                    PhotoGridItem(asset: photo.asset)
                }
                .cornerRadius(8.0)
                .aspectRatio(1, contentMode: .fit)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: geoProxy.size.height * 0.25
            )
            .background(.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            HStack{
                Text("Buraya ne yazılacak okuyamadım ama böyle bir alan var")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
            }
        }
        VStack{
            Button{
                
            } label: {
                Image(systemName: "gear")
                    .foregroundStyle(.black)
            }
            Spacer()
            Button{
                
            } label: {
                Image(systemName: "heart")
                    .foregroundStyle(.black)
            }
            Spacer()
            Button{
                
            } label: {
                Image(systemName: "archivebox")
                    .foregroundStyle(.black)
            }
            Spacer()
            Button{
                
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.black)
            }
            Spacer()
        }
        .frame(
            height: geoProxy.size.height * 0.3
        )
    }
    .padding()
    .frame(
        width: geoProxy.size.width,
        height: geoProxy.size.height * 0.35
    )
}


#Preview {
    SearchView()
}
