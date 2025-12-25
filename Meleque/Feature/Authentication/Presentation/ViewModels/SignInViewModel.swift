//
//  SignInViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var isSignedIn = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    @Injected var signInUseCase: SignInUseCaseProtocol
    
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        let credentials = SignInCredentials(email: email, password: password)
        signInUseCase.execute(credentials: credentials)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Publisher completed successfully.")
                case .failure(let error):
                    print("Error: \(error)")
                    self.isSignedIn = false
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { user in
                self.currentUser = user
                self.isSignedIn = true
            }
            .store(in: &cancellables)
        isLoading = false
    }
    
    func signUp(email: String, password: String, displayName: String?) async {
        isLoading = true
        errorMessage = nil
//        
//        do {
//            let credentials = SignUpCredentials(email: email, password: password, displayName: displayName)
//            let user = try await repository.signUp(credentials: credentials)
//            currentUser = user
//            isSignedIn = true
//        } catch {
//            errorMessage = error.localizedDescription
//            isSignedIn = false
//        }
//        
        isLoading = false
    }
    
    func signOut() async {
        isLoading = true
        errorMessage = nil
        
//        do {
//            try await repository.signOut()
//            currentUser = nil
//            isSignedIn = false
//        } catch {
//            errorMessage = error.localizedDescription
//        }
        
        isLoading = false
    }
    
    func deleteAccount() async {
        isLoading = true
        errorMessage = nil
        
//        do {
//            try await repository.deleteAccount()
//            currentUser = nil
//            isSignedIn = false
//        } catch {
//            errorMessage = error.localizedDescription
//        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
}
