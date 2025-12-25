//
//  OnBoardView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

struct OnBoardView: View {
    
    
    var body: some View {
        GeometryReader { geoProxy in
            NavigationStack{
                ZStack{
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 32) {
                        Spacer()
                        
                        VStack(spacing: 12) {
                            Image(systemName: "leaf.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.green)
                            
                            Text("Farm Asistan ")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Digital support for efficient agriculture")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        
                        VStack(spacing: 16) {
                            NavigationLink {
                                SignInView()
                            }label:{
                                Text("Sign In")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.9))
                                    .foregroundColor(.green)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                            NavigationLink {
//                                SignUpView()
                            } label: {
                                Text("Sign Up")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                        }
                        VStack {
                            Text("Or")
                                .foregroundColor(.white.opacity(0.6))
                            Button(action: {
                                //TODO: apple giriş ile bağla burayı
                            }) {
                                Label("Continue with Apple", systemImage: "apple.logo")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}


#Preview {
    NavigationStack{
        OnBoardView()
    }
}
