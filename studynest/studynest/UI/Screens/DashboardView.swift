//
//  DashboardView.swift
//  studynest
//
//  Dashboard with TabView (Home, Bookings, Profile, Settings)
//

import SwiftUI

enum DashboardTab {
    case home
    case bookings
    case profile
    case settings
}

struct DashboardView: View {
    @State private var selectedTab: DashboardTab = .home
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var dashboardViewModel = DashboardViewModel()
    @StateObject private var bookingHistoryViewModel = BookingHistoryViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeContentView(viewModel: dashboardViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(DashboardTab.home)
            
            BookingHistoryView(viewModel: bookingHistoryViewModel)
                .tabItem {
                    Label("Bookings", systemImage: "calendar")
                }
                .tag(DashboardTab.bookings)
            
            ProfileView(viewModel: dashboardViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(DashboardTab.profile)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(DashboardTab.settings)
        }
        .tint(.primaryBlue)
        .onAppear {
            Task {
                await dashboardViewModel.loadDashboard()
                await bookingHistoryViewModel.loadBookings(userId: "user_1")
            }
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(NavigationManager())
}
