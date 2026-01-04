//
//  PhotoGalleryView.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/25/25.
//


import SwiftUI
internal import Photos
import Combine

// MARK: - Ana View
struct PhotoGalleryView: View {
    
    @EnvironmentObject private var vm : PhotoGalleryViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    private static let initialColumns = 3
    @State private var isAddingPhoto = false
    @State private var isEditing = false
    
    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
    @State private var numColumns = initialColumns
    
    private var columnsTitle: String {
        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
    }
    
    var body: some View {
        NavigationStack{
            Group {
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
                            if isEditing {
                                ColumnStepper(title: columnsTitle, range: 1...8, columns: $gridColumns)
                                    .padding()
                            }
                            ScrollView {
                                LazyVGrid(columns: gridColumns) {
                                    ForEach(vm.photos) { item in
                                        GeometryReader { geo in
                                            PhotoGridItem(asset: item.asset)
                                        }
                                        .cornerRadius(8.0)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay(alignment: .topTrailing) {
                                            if isEditing {
                                                Button {
                                                    
                                                } label: {
                                                    Image(systemName: "xmark.square.fill")
                                                        .font(Font.title)
                                                        .symbolRenderingMode(.palette)
                                                        .foregroundStyle(.white, .red)
                                                }
                                                .offset(x: 7, y: -7)
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .navigationTitle("Fotoğraflarım")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "Done" : "Edit") {
                        withAnimation { isEditing.toggle() }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddingPhoto = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(isEditing)
                }
            }
        }
    }
}

struct ColumnStepper: View {
    let title: String
    let range: ClosedRange<Int>
    @Binding var columns: [GridItem]
    @State private var numColumns: Int

    init(title: String, range: ClosedRange<Int>, columns: Binding<[GridItem]>) {
        self.title = title
        self.range = range
        self._columns = columns
        self.numColumns = columns.count
    }

    var body: some View {
        Stepper(title, value: $numColumns, in: range, step: 1) { _ in
            withAnimation { columns = Array(repeating: GridItem(.flexible()), count: numColumns) }
        }
    }
}



// MARK: - Grid Item View
struct PhotoGridItem: View {
    let asset: PHAsset
    @State private var image: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .onAppear {
            loadImage()
        }
    }
    
    
    private func loadImage() {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        option.deliveryMode = .opportunistic
        
        let size = CGSize(width: 300, height: 300)
        
        manager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: option
        ) { result, _ in
            if let result = result {
                self.image = result
            }
        }
    }
}

// MARK: - Photo Model
struct Photo: Identifiable {
    let id: String
    let asset: PHAsset
}

// MARK: - ViewModel
class PhotoGalleryViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined
    
    func checkAuthorization() {
        authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        if authorizationStatus == .authorized || authorizationStatus == .limited {
            fetchPhotos()
        }
    }
    
    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                self?.authorizationStatus = status
                if status == .authorized || status == .limited {
                    self?.fetchPhotos()
                }
            }
        }
    }
    
    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let results = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var tempPhotos: [Photo] = []
        results.enumerateObjects { asset, _, _ in
            tempPhotos.append(Photo(id: asset.localIdentifier, asset: asset))
        }
        
        DispatchQueue.main.async {
            self.photos = tempPhotos
        }
    }
}

// MARK: - Preview
#Preview {
    PhotoGalleryView()
}
