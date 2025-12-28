//
//  DashboardViewModel.swift
//  studynest
//
//  ViewModel for dashboard functionality
//

import Foundation
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var state: ViewState<DashboardStats> = .idle
    @Published var currentBooking: Booking?
    @Published var currentUser: User?
    
    private let repository: StudyNestRepository
    
    init(repository: StudyNestRepository? = nil) {
        self.repository = repository ?? StudyNestRepository()
    }
    
    func loadDashboard() async {
        state = .loading
        
        let stats = await repository.getDashboardStats()
        currentBooking = await repository.getCurrentBooking(userId: currentUser?.id ?? "user_1")
        currentUser = repository.getStoredUser()
        
        state = .success(stats)
    }
    
    func logout() {
        repository.logout()
        currentUser = nil
        currentBooking = nil
        state = .idle
    }
}
