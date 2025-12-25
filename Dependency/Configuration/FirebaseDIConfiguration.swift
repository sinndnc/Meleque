//
//  FirebaseAppConfiguration.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//


import Foundation
import Firebase
import FirebaseAuth

class FirebaseDIConfiguration {
    
    static let shared = FirebaseDIConfiguration()
    
    private init() {}
    
    func configure() {
        FirebaseApp.configure()
        
        configureAuth()
        configureFirestore()
    }
    
    private func configureAuth() {
        // Enable persistence for offline support
        Auth.auth().useAppLanguage()
        
        // Set custom timeout
        // Auth.auth().settings?.appVerificationDisabledForTesting = false // Only for testing
    }
    
    private func configureFirestore(){
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        Firestore.firestore().settings = settings
    }
    
    func removeAuthStateListener(_ handle: AuthStateDidChangeListenerHandle) {
        Auth.auth().removeStateDidChangeListener(handle)
    }
}

