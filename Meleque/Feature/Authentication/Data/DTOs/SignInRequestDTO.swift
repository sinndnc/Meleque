//
//  SignInRequestDTO.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation

struct SignInRequestDTO: Codable {
    let email: String
    let password: String
    let rememberMe: Bool
    let deviceInfo: DeviceInfoDTO
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case rememberMe = "remember_me"
        case deviceInfo = "device_info"
    }
    
    init(from credentials: SignInCredentials) {
        self.email = credentials.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        self.password = credentials.password
        self.rememberMe = credentials.rememberMe
        self.deviceInfo = DeviceInfoDTO.current
    }
}
