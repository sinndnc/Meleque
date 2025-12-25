//
//  RootView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject private var rootViewModel: RootViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
//    @EnvironmentObject private var cartViewModel: CartViewModel
//    @EnvironmentObject private var deliveryViewModel: DeliveryViewModel
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $rootViewModel.selectedTab){
                Tab("Home", systemImage: "house", value: .home) {
                    HomeView()
                        .tag(TabEnum.home)
                }
                Tab("Search", systemImage: "magnifyingglass", value: .search) {
                    SearchView()
                        .tag(TabEnum.search)
                }
                Tab("Camera", systemImage: "camera",value: .camera){
                    CameraView()
                        .tag(TabEnum.camera)
                }
                Tab("Calendar", systemImage: "calendar",value: .calendar){
                    CalendarView()
                        .tag(TabEnum.calendar)
                }
                Tab("Account", systemImage: "person.circle", value: .account) {
                    AccountView()
                        .tag(TabEnum.account)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    RootView()
}
