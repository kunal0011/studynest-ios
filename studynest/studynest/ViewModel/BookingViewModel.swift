//
//  BookingViewModel.swift
//  studynest
//
//  ViewModel for creating bookings
//

import Foundation
import SwiftUI
import Combine

@MainActor
class BookingViewModel: ObservableObject {
    @Published var state: ViewState<Booking> = .idle
    
    private let repository: StudyNestRepository
    
    init(repository: StudyNestRepository? = nil) {
        self.repository = repository ?? StudyNestRepository()
    }
    
    func createBooking(_ booking: Booking) async {
        state = .loading
        
        let success = await repository.createBooking(booking)
        
        if success {
            state = .success(booking)
        } else {
            state = .error("Failed to create booking")
        }
    }
}
