//
//  AppDIConfiguration.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation
import FirebaseAuth

class AppDIConfiguration {
    
    static let shared = AppDIConfiguration()
    
    
    static func configure() {
        let container = DIContainer.shared
        
        
        //MARK: - Auth Configuration
        container.register(AuthRemoteDataSourceProtocol.self,scope: .singleton) { _ in
            AuthRemoteDataSource(auth: .auth())
        }
        container.register(AuthRepositoryProtocol.self, scope: .singleton) { container in
            AuthRepository(
                remoteDataSource:  container.resolve(AuthRemoteDataSourceProtocol.self)
            )
        }
        container.register(SignInUseCaseProtocol.self, scope: .singleton) { container in
            SignInUseCase(
                repository: container.resolve(AuthRepositoryProtocol.self)
            )
        }
        
    }
}
