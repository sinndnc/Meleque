//
//  SignInResponseDTO.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation

struct SignInResponseDTO: Codable {
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: String?
    let emailVerified: Bool
    let metadata: UserMetadataDTO?
}

extension SignInResponseDTO {
    func toDomain() -> User {
        User(
            email: "", phone: "", lastName: "", firstName: ""
        )
    }
}
