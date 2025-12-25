//
//  SignInUseCaseProtocol.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation
import Combine

protocol SignInUseCaseProtocol {
    func execute(credentials: SignInCredentials) -> AnyPublisher<User, AuthError>
}

final class SignInUseCase: SignInUseCaseProtocol {
    
    // MARK: - Properties
    private let repository: AuthRepositoryProtocol
//    private let tokenManager: TokenManager
//    private let analyticsService: AnalyticsService
    
    // MARK: - Initialization
    init(
        repository: AuthRepositoryProtocol,
//        tokenManager: TokenManager,
//        analyticsService: AnalyticsService
    ) {
        self.repository = repository
//        self.tokenManager = tokenManager
//        self.analyticsService = analyticsService
    }
    
    // MARK: - Public Methods
    func execute(credentials: SignInCredentials) -> AnyPublisher<User, AuthError> {
        // Validate credentials first
        guard validateCredentials(credentials) else {
            print("Validate Error")
            return Fail(error: AuthError.invalidCredentials)
                .eraseToAnyPublisher()
        }
        
        // Track login attempt
//        analyticsService.track(.loginAttempt)
        
        return repository.signIn(credentials: credentials)
            .handleEvents(
                receiveOutput: { [weak self] user in
                    // Save token securely
//                    self?.tokenManager.saveToken(token)
                    // Track successful login
//                    self?.analyticsService.track(.loginSuccess)
                },
                receiveCompletion: { [weak self] completion in
                    print("Completion Error:")
                    if case .failure(let error) = completion {
                        print("Error: \(error)")
                        // Track login failure
//                        self?.analyticsService.track(.loginFailure(error: error))
                    }
                }
            )
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    private func validateCredentials(_ credentials: SignInCredentials) -> Bool {
        return !credentials.email.isEmpty  &&
               !credentials.password.isEmpty &&
               credentials.password.count >= 6
    }
}
