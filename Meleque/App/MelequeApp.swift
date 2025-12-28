//
//  MelequeApp.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//
import SwiftUI

@main
struct MelequeApp: App {
    
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var rootViewModel = RootViewModel()
    
    @UIApplicationDelegateAdaptor(MelequeAppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
                .environmentObject(rootViewModel)
                .environmentObject(userViewModel)
        }
    }
}
