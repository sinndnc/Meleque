//
//  AuthRepository.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation
import Combine

final class AuthRepository : AuthRepositoryProtocol{
    
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    
    init(
        remoteDataSource: AuthRemoteDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
    }
    
    func signIn(credentials: SignInCredentials) -> AnyPublisher<User, AuthError> {
        let request = SignInRequestDTO(from: credentials)
        
        return remoteDataSource.login(request: request)
            .map { dto in
                let user = dto.toDomain()
//                self.localDataSource.saveUser(user)
                return user
            }
            .eraseToAnyPublisher()
    }
    
    func signUp(with credentials: SignInCredentials, displayName: String?) -> AnyPublisher<User, AuthError> {
        let request = SignInRequestDTO(from: credentials)
        
        return remoteDataSource.signUp(request: request, displayName: displayName)
            .map { dto in
                let user = dto.toDomain()
//                self.localDataSource.saveUser(user)
                return user
            }
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, AuthError> {
        return remoteDataSource.logout()
            .handleEvents(receiveOutput: { [weak self] _ in
//                self?.localDataSource.clearUser()
            })
            .eraseToAnyPublisher()
    }
    
    func getCurrentUser() -> AnyPublisher<User, AuthError> {
        return remoteDataSource.getCurrentUser()
              .tryMap { dto in
                  let user = dto.toDomain()
                  // self.localDataSource.saveUser(user)
                  return user
              }
              .mapError { error in
                  if let authError = error as? AuthError {
                      return authError
                  }
                  return AuthError.unknown(error.localizedDescription)
              }
              .eraseToAnyPublisher()
    }
    
    func resetPassword(email: String) -> AnyPublisher<Void, AuthError> {
        return remoteDataSource.resetPassword(email: email)
    }
    
}
