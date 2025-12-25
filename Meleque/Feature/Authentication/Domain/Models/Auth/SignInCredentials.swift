//
//  SignInCredentials.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//


import Foundation

struct SignInCredentials : Codable {
    let email: String
    let password: String
    let rememberMe: Bool
    
    init(email: String, password: String, rememberMe: Bool = false) {
        self.email = email
        self.password = password
        self.rememberMe = rememberMe
    }
}
