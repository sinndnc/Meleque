//
//  AccountView.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//
import SwiftUI

struct AccountView: View {
    var body: some View {
        GeometryReader { geoProxy in
            NavigationStack{
                ScrollView(.vertical) {
                    VStack{
                        ScrollView(.horizontal) {
                            HStack{
                                ForEach(1...10,id:\.self){ int in
                                    VStack{
                                        Circle()
                                            .frame(
                                                width: 50,
                                                height: 50
                                            )
                                            .foregroundStyle(.gray.opacity(0.3))
                                        Text("Profil Ismi \(int)")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundStyle(.gray)
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(
                            width: geoProxy.size.width,
                            height: geoProxy.size.height * 0.1
                        )
                        
                        PhotoGalleryView()
                            .frame(
                                width: geoProxy.size.width,
                                height: geoProxy.size.height * 0.9
                            )
                    }
                    .frame(
                        width: geoProxy.size.width,
                        height: geoProxy.size.height
                    )
                }
                .navigationTitle("Home")
            }
        }    }
}

#Preview {
    AccountView()
}
