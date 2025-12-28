//
//  MelequeAppDelegate.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//
import Foundation
import UIKit
import FirebaseCore

final class MelequeAppDelegate : NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupDependencyContainer()
        return true
    }
}

extension MelequeAppDelegate  {
    
    func setupDependencyContainer() {
        FirebaseDIConfiguration.shared.configure()
        AppDIConfiguration.configure()
    }
    
}
