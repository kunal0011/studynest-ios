//
//  PaymentViewModel.swift
//  studynest
//
//  ViewModel for payment processing
//

import Foundation
import SwiftUI
import Combine

@MainActor
class PaymentViewModel: ObservableObject {
    @Published var selectedPaymentMethod: PaymentMethod = .card
    @Published var isProcessing: Bool = false
    @Published var paymentSuccess: Bool = false
    @Published var errorMessage: String?
    
    private let repository: StudyNestRepository
    
    var booking: Booking?
    
    init(repository: StudyNestRepository? = nil) {
        self.repository = repository ?? StudyNestRepository()
    }
    
    func setBookingData(seat: Seat?, plan: Plan?, date: Date, userId: String) {
        guard let seat = seat, let plan = plan else { return }
        
        let startTime = date
        let endTime: Date
        
        switch plan.duration {
        case "1 Day":
            endTime = Calendar.current.date(byAdding: .day, value: 1, to: startTime) ?? startTime
        case "7 Days":
            endTime = Calendar.current.date(byAdding: .day, value: 7, to: startTime) ?? startTime
        case "30 Days":
            endTime = Calendar.current.date(byAdding: .day, value: 30, to: startTime) ?? startTime
        default:
            endTime = Calendar.current.date(byAdding: .day, value: 1, to: startTime) ?? startTime
        }
        
        let gst = plan.price * 0.18
        let total = plan.price + gst
        
        booking = Booking(
            seatId: seat.id,
            seatNumber: seat.seatNumber,
            userId: userId,
            startTime: startTime,
            endTime: endTime,
            status: .active,
            planName: plan.name,
            totalAmount: total
        )
    }
    
    func processPayment() async {
        guard let booking = booking else {
            errorMessage = "No booking data available"
            return
        }
        
        isProcessing = true
        errorMessage = nil
        
        // Simulate payment processing
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let success = await repository.createBooking(booking)
        
        isProcessing = false
        
        if success {
            paymentSuccess = true
        } else {
            errorMessage = "Payment failed. Please try again."
        }
    }
}
