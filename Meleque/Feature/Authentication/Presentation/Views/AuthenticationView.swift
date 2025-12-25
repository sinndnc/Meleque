//
//  AuthenticationView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject private var userViewModel : UserViewModel
    
    var body: some View {
        ZStack{
            if false {
                ProgressView()
            } else if userViewModel.isAuthenticated {
                RootView()
                    .environmentObject(userViewModel)
                
            } else {
                OnBoardView()
            }
        }
    }
    
}
