//
//  SeatAvailabilityViewModel.swift
//  studynest
//
//  ViewModel for seat availability and selection
//

import Foundation
import SwiftUI
import Combine

@MainActor
class SeatAvailabilityViewModel: ObservableObject {
    @Published var state: ViewState<[Seat]> = .idle
    @Published var selectedDate: Date = Date()
    @Published var selectedSeat: Seat?
    
    private let repository: StudyNestRepository
    
    init(repository: StudyNestRepository? = nil) {
        self.repository = repository ?? StudyNestRepository()
    }
    
    func loadSeats() async {
        state = .loading
        
        let seats = await repository.getSeats(date: selectedDate, hallId: "hall_1")
        
        state = .success(seats)
    }
    
    func selectSeat(_ seat: Seat) {
        if seat.isAvailable {
            if selectedSeat?.id == seat.id {
                selectedSeat = nil
            } else {
                selectedSeat = seat
            }
        }
    }
    
    func dateChanged() async {
        selectedSeat = nil
        await loadSeats()
    }
}
