//
//  AuthRepositoryProtocol.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation
import Combine

protocol AuthRepositoryProtocol{
    func signIn(credentials: SignInCredentials) -> AnyPublisher<User, AuthError>
    func signUp(with credentials: SignInCredentials, displayName: String?) -> AnyPublisher<User, AuthError>
    func logout() -> AnyPublisher<Void, AuthError>
    func getCurrentUser() -> AnyPublisher<User, AuthError>
    func resetPassword(email: String) -> AnyPublisher<Void, AuthError>
}
