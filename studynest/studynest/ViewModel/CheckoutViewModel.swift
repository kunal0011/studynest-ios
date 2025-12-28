//
//  CheckoutViewModel.swift
//  studynest
//
//  ViewModel for checkout and order summary
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CheckoutViewModel: ObservableObject {
    @Published var selectedSeat: Seat?
    @Published var selectedPlan: Plan?
    @Published var selectedDate: Date = Date()
    
    var subtotal: Double {
        selectedPlan?.price ?? 0
    }
    
    var gst: Double {
        subtotal * 0.18 // 18% GST
    }
    
    var total: Double {
        subtotal + gst
    }
    
    func setCheckoutData(seat: Seat?, plan: Plan?, date: Date) {
        self.selectedSeat = seat
        self.selectedPlan = plan
        self.selectedDate = date
    }
}
