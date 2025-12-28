//
//  BookingHistoryViewModel.swift
//  studynest
//
//  ViewModel for booking history
//

import Foundation
import SwiftUI
import Combine

@MainActor
class BookingHistoryViewModel: ObservableObject {
    @Published var state: ViewState<[Booking]> = .idle
    
    private let repository: StudyNestRepository
    
    init(repository: StudyNestRepository? = nil) {
        self.repository = repository ?? StudyNestRepository()
    }
    
    func loadBookings(userId: String) async {
        state = .loading
        
        let bookings = await repository.syncBookings(userId: userId)
        
        state = .success(bookings)
    }
}
