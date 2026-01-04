//
//  HomeView.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//
import SwiftUI
import PhotosUI
import Combine
import Foundation

// MARK: - Models
struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
}

// MARK: - HomeView
struct HomeView: View {
    @State private var searchText = ""
    @State private var selectedItem: MenuItem?
    
    var body: some View {
        NavigationStack {
            GeometryReader { geoProxy in
                ScrollView {
                    VStack(spacing: 0) {
                        MenuGridView(selectedItem: $selectedItem)
                            .frame(height: geoProxy.size.height)
                    }
                }
            }
            .navigationTitle("Hoş Geldiniz")
            .navigationSubtitle("Sinan Dinç")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Ara...")
            .sheet(item: $selectedItem) { item in
                DetailView(item: item)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    },label: {
                        Image(systemName: "bell.fill")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    })
                }
            }
        }
    }
}

struct MenuGridView: View {
    @Binding var selectedItem: MenuItem?
    
    let menuItems: [[MenuItem]] = [
        // İlk Satır
        [
            MenuItem(title: "Galeri", icon: "photo.on.rectangle.angled", color: .blue, action: {}),
            MenuItem(title: "Kamera", icon: "camera.fill", color: .green, action: {}),
            MenuItem(title: "Dosyalar", icon: "folder.fill", color: .orange, action: {})
        ],
        // İkinci Satır
        [
            MenuItem(title: "Ayarlar", icon: "gearshape.fill", color: .purple, action: {}),
            MenuItem(title: "Profil", icon: "person.circle.fill", color: .pink, action: {}),
            MenuItem(title: "Favoriler", icon: "star.fill", color: .yellow, action: {})
        ],
        // Üçüncü Satır
        [
            MenuItem(title: "Paylaş", icon: "square.and.arrow.up.fill", color: .indigo, action: {}),
            MenuItem(title: "Takvim", icon: "calendar", color: .red, action: {}),
            MenuItem(title: "Mesajlar", icon: "message.fill", color: .teal, action: {})
        ]
    ]
    
    var body: some View {
        GeometryReader { geoProxy in
            VStack(spacing: 0) {
                ForEach(Array(menuItems.enumerated()), id: \.offset) { index, row in
                    HStack(spacing: 0) {
                        ForEach(Array(row.enumerated()), id: \.offset) { colIndex, item in
                            MenuItemCard(
                                item: item,
                                cornerStyle: getCornerStyle(row: index, col: colIndex),
                                isMiddle: index == 1 && colIndex == 1
                            )
                            .frame(
                                width: geoProxy.size.width / 3,
                                height: geoProxy.size.height / 3
                            )
                            .onTapGesture {
                                selectedItem = item
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getCornerStyle(row: Int, col: Int) -> CornerStyle {
        if row == 0 && col == 0 { return .topLeft }
        if row == 0 && col == 2 { return .topRight }
        if row == 2 && col == 0 { return .bottomLeft }
        if row == 2 && col == 2 { return .bottomRight }
        return .none
    }
}

// MARK: - Corner Style
enum CornerStyle {
    case topLeft, topRight, bottomLeft, bottomRight, none
}

// MARK: - Menu Item Card
struct MenuItemCard: View {
    let item: MenuItem
    let cornerStyle: CornerStyle
    let isMiddle: Bool
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [item.color.opacity(0.8), item.color],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 12) {
                Image(systemName: item.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                Text(item.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .applyCornerRadius(style: cornerStyle, isMiddle: isMiddle)
        .shadow(color: item.color.opacity(0.3), radius: 5, x: 0, y: 2)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - View Extension for Corner Radius
extension View {
    @ViewBuilder
    func applyCornerRadius(style: CornerStyle, isMiddle: Bool) -> some View {
        if isMiddle {
            self.clipShape(Circle())
        } else {
            switch style {
            case .topLeft:
                self.cornerRadius(40, corners: [.topLeft])
            case .topRight:
                self.cornerRadius(40, corners: [.topRight])
            case .bottomLeft:
                self.cornerRadius(40, corners: [.bottomLeft])
            case .bottomRight:
                self.cornerRadius(40, corners: [.bottomRight])
            case .none:
                self
            }
        }
    }
}

// MARK: - Detail View
struct DetailView: View {
    let item: MenuItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: item.icon)
                    .font(.system(size: 80))
                    .foregroundColor(item.color)
                
                Text(item.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Bu özellik geliştirme aşamasındadır.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle(item.title)
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

// MARK: - Rounded Corner Shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Corner Radius Modifier
struct CornerRadiusModifier: ViewModifier {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func body(content: Content) -> some View {
        content.clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        modifier(CornerRadiusModifier(radius: radius, corners: corners))
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
