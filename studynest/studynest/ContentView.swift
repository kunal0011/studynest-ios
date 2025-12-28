//
//  ContentView.swift
//  studynest
//
//  Root navigation container
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager()
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            // Start with Login
            LoginView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .login:
                        LoginView()
                        
                    case .dashboard:
                        DashboardView()
                            .navigationBarBackButtonHidden(true)
                        
                    case .seatAvailability:
                        SeatAvailabilityView()
                        
                    case .selectPlan(let seat, let date):
                        SelectPlanView(seat: seat, date: date)
                        
                    case .checkout(let seat, let plan, let date):
                        CheckoutView(seat: seat, plan: plan, date: date)
                        
                    case .payment(let seat, let plan, let date):
                        PaymentView(seat: seat, plan: plan, date: date)
                        
                    case .bookingHistory:
                        BookingHistoryView(viewModel: BookingHistoryViewModel())
                        
                    case .profile:
                        ProfileView(viewModel: DashboardViewModel())
                        
                    case .settings:
                        SettingsView()
                    }
                }
        }
        .environmentObject(navigationManager)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [UserEntity.self, BookingEntity.self], inMemory: true)
}
