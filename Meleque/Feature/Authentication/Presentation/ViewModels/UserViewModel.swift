//
//  UserViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation
import Combine
import FirebaseFirestore

class UserViewModel : ObservableObject{
//    
//    @Published var user: User?
//    @Published var deliveries: [Delivery] = []
//    
    @Published var isLoading = false
    @Published var isAuthenticated = true
    
    @Published var cancellables: Set<AnyCancellable> = []
//
//    @Injected private var checkUserUseCase: CheckUserUseCaseProtocol
//    @Injected private var listenUserUseCase: ListenUserUseCaseProtocol
//    @Injected private var updatedefaultAddressUseCase: UpdateDefaultAddressUseCaseProtocol
//    
//    
//    func checkAuthenticationState() {
//        if user == nil{
//            isLoading = true
//        }
//        checkUserUseCase.execute()
//            .sink { completion in
//                self.isLoading = false
//            } receiveValue: { user in
//                
//                self.user = user
//                if let id = user.id {
//                    self.loadUser(of: id)
//                }
//                
//                self.isLoading = false
//                self.isAuthenticated = true
//            }
//            .store(in: &cancellables)
//    }
//    
//    func updateDefaultAddress(_ address: Address) {
//        guard let userId = user?.id else { return }
//        
//        if user == nil{
//            isLoading = true
//        }
//        updatedefaultAddressUseCase.execute(of: userId, for: address.id ?? "")
//            .receive(on: DispatchQueue.main)
//            .sink(
//                receiveCompletion: { [weak self] completion in
//                    self?.isLoading = false
//                    
//                    if case .failure(let error) = completion {
//                        Logger.log("VIEWMODEL: \(error)")
//                    }
//                },
//                receiveValue: { _ in
//                   
//                }
//            )
//            .store(in: &cancellables)
//    }
//    
//    private func loadUser(of id: String) {
//        if user == nil{
//            isLoading = true
//        }
//        listenUserUseCase.execute(by: id)
//            .receive(on: DispatchQueue.main)
//            .sink(
//                receiveCompletion: { completion in
//                    switch completion {
//                    case .failure(let error):
//                        Logger.log("VIEW MODEL: Error: \(error)")
//                    case .finished: break
//                    }
//                },
//                receiveValue: { [weak self] user in
//                    self?.user = user
//                    self?.isLoading = false
//                }
//            )
//            .store(in: &cancellables)
//    }
    
}
