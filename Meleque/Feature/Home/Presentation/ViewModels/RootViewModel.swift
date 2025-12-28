//
//  RootViewModel.swift
//  Meleque
//
//  Created by Sinan Dinç on 8/7/25.
//
import Combine
import Foundation

final class RootViewModel: ObservableObject {
    @Published var selectedTab: TabEnum = .home
    
    @Published var showingLocation = false
    
    //MARK: -  Loading States
    @Published var isLoadingUser = false
    @Published var isLoadingProducts = false
    @Published var isLoadingCategories = false
    @Published var isLoadingRecipes = false
    @Published var isLoadingDeliveryStatus = false
}
