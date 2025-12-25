//
//  AuthRemoteDataSource.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation
import FirebaseAuth
import Combine

protocol AuthRemoteDataSourceProtocol {
    func login(request: SignInRequestDTO) -> AnyPublisher<SignInResponseDTO, AuthError>
    func signUp(request: SignInRequestDTO, displayName: String?) -> AnyPublisher<SignInResponseDTO, AuthError>
    func logout() -> AnyPublisher<Void, AuthError>
    func getCurrentUser() -> AnyPublisher<SignInResponseDTO, AuthError>
    func resetPassword(email: String) -> AnyPublisher<Void, AuthError>
}

class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    
    private let auth : Auth
    
    init(auth: Auth) {
        self.auth = auth
    }
    
    func login(request: SignInRequestDTO) -> AnyPublisher<SignInResponseDTO, AuthError> {
        Future { [weak self] promise in
            self?.auth.signIn(withEmail: request.email, password: request.password) { result, error in
                if let error = error {
                    print("Error Remote: \(error)")
                    promise(.failure(self?.mapFirebaseError(error) ?? .unknown(error.localizedDescription)))
                    return
                }
                
                guard let user = result?.user else {
                    Logger.log("Error user: \(String(describing: error))")
                    promise(.failure(.unauthorized))
                    return
                }
                
                let dto = SignInResponseDTO(
                    uid: user.uid,
                    email: user.email,
                    displayName: user.displayName,
                    photoURL: user.photoURL?.absoluteString,
                    emailVerified: user.isEmailVerified,
                    metadata: UserMetadataDTO(
                        creationTime: user.metadata.creationDate?.ISO8601Format(),
                        lastSignInTime: user.metadata.lastSignInDate?.ISO8601Format()
                    )
                )
                
                promise(.success(dto))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(request: SignInRequestDTO, displayName: String?) -> AnyPublisher<SignInResponseDTO, AuthError> {
        Future { [weak self] promise in
            self?.auth.createUser(withEmail: request.email, password: request.password) { result, error in
                if let error = error {
                    promise(.failure(self?.mapFirebaseError(error) ?? .unknown(error.localizedDescription)))
                    return
                }
                
                guard let user = result?.user else {
                    promise(.failure(.unknown("Failed to create user")))
                    return
                }
                
                // Update display name if provided
                if let displayName = displayName {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { _ in }
                }
                
                let dto = SignInResponseDTO(
                    uid: user.uid,
                    email: user.email,
                    displayName: displayName,
                    photoURL: user.photoURL?.absoluteString,
                    emailVerified: user.isEmailVerified,
                    metadata: UserMetadataDTO(
                        creationTime: user.metadata.creationDate?.ISO8601Format(),
                        lastSignInTime: user.metadata.lastSignInDate?.ISO8601Format()
                    )
                )
                
                promise(.success(dto))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, AuthError> {
        Future { [weak self] promise in
            do {
                try self?.auth.signOut()
                promise(.success(()))
            } catch {
                promise(.failure(.unauthorized))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getCurrentUser() -> AnyPublisher<SignInResponseDTO, AuthError> {
        Just(auth.currentUser)
            .tryMap { user in
                guard let user = user else {
                    throw AuthError.unauthorized
                }
                
                return SignInResponseDTO(
                    uid: user.uid,
                    email: user.email,
                    displayName: user.displayName,
                    photoURL: user.photoURL?.absoluteString,
                    emailVerified: user.isEmailVerified,
                    metadata: UserMetadataDTO(
                        creationTime: user.metadata.creationDate?.ISO8601Format(),
                        lastSignInTime: user.metadata.lastSignInDate?.ISO8601Format()
                    )
                )
            }
            .mapError { error in
                if let authError = error as? AuthError {
                    return authError
                }
                return AuthError.unknown(error.localizedDescription) // veya uygun bir default error
            }
            .eraseToAnyPublisher()
    }
    
    func resetPassword(email: String) -> AnyPublisher<Void, AuthError> {
        Future { [weak self] promise in
            self?.auth.sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    promise(.failure(self?.mapFirebaseError(error) ?? .unknown(error.localizedDescription)))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func mapFirebaseError(_ error: Error) -> AuthError {
        guard let authError = error as NSError? else {
            return .unknown(error.localizedDescription)
        }
        
        switch authError.code {
        case AuthErrorCode.invalidEmail.rawValue,
             AuthErrorCode.wrongPassword.rawValue:
            return .invalidCredentials
        case AuthErrorCode.userNotFound.rawValue:
            return .unauthorized
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailAlreadyInUse
        case AuthErrorCode.networkError.rawValue:
            return .networkError(error)
        default:
            return .unknown(authError.localizedDescription)
        }
    }
}
