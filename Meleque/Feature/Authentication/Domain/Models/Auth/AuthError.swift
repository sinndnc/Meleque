//
//  AuthError.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case networkError(Error)
    case serverError(String)
    case unauthorized
    case weakPassword
    case accountLocked
    case emailAlreadyInUse
    case emailNotVerified
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .unauthorized:
            return "Unauthorized access"
        case .accountLocked:
            return "Account is temporarily locked"
        case .emailNotVerified:
            return "Please verify your email address"
        case .emailAlreadyInUse:
            return "This Email is using please enter different Email"
        case .weakPassword:
            return "Please enter more powerful password"
        case .unknown(let error):
            return "Unknown Error \(error)"
        }
    }
}
