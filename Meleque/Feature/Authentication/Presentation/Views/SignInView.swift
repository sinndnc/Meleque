//
//  SignInView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//



import SwiftUI

struct SignInView: View {
    @State private var email: String =  "sinandinc77@icloud.com"
    @State private var password: String = "Snn20012004"
    @State private var isPasswordVisible = false
    
    @Environment(\.dismiss) private var  dismiss
    @StateObject private var viewModel : SignInViewModel = SignInViewModel()
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                TextField("E-Mail", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button{
                Task{
                viewModel.signIn(email: email, password: password)
                }
            }label: {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            
            Button("Did you forget your password?") {
                // Şifre sıfırlama
            }
            .font(.footnote)
            .foregroundColor(.gray)
            
            Spacer()
        }
        .navigationDestination(isPresented: $viewModel.isSignedIn) {
            RootView()
        }
    }
}


#Preview {
    SignInView()
}
