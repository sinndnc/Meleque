//
//  PostDetailView.swift
//  Meleque
//
//  Created by Sinan Dinç on 1/4/26.
//

import SwiftUI

struct PostDetailView: View {
    let photo: Photo
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Fotoğraf
                PhotoGridItem(asset: photo.asset)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    // Başlık
                    Text("My photo")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Açıklama
                    
                    Text("My photo desciprion")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    // Kullanıcı bilgisi
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text("Sinan Dinç")
                                .font(.headline)
                            Text(Date().description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    // İstatistikler
                    HStack(spacing: 24) {
                        Label("\(63)", systemImage: "heart.fill")
                            .foregroundColor(.red)
                        
                        Label("\(15)", systemImage: "bubble.right.fill")
                            .foregroundColor(.blue)
                        
                        Label("\(357)", systemImage: "eye.fill")
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .font(.subheadline)
                }
                .padding()
            }
        }
        .navigationTitle("Post Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

