//
//  PaymentView.swift
//  studynest
//
//  Payment screen with payment method selection
//

import SwiftUI

struct PaymentView: View {
    @StateObject private var viewModel = PaymentViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    let seat: Seat
    let plan: Plan
    let date: Date
    
    private var total: Double {
        let gst = plan.price * 0.18
        return plan.price + gst
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        // Amount Card
                        VStack(spacing: 8) {
                            Text("Amount to Pay")
                                .font(.subheadline)
                                .foregroundColor(.neutralMedium)
                            
                            Text("₹\(Int(total))")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundColor(.primaryBlue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                        
                        // Payment Methods
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Select Payment Method")
                                .font(.headline)
                                .foregroundColor(.neutralDark)
                            
                            ForEach(PaymentMethod.allCases) { method in
                                PaymentMethodItem(
                                    method: method,
                                    isSelected: viewModel.selectedPaymentMethod == method,
                                    onTap: {
                                        viewModel.selectedPaymentMethod = method
                                    }
                                )
                            }
                        }
                        
                        // Secure Payment Info
                        HStack(spacing: 8) {
                            Image(systemName: "lock.shield.fill")
                                .foregroundColor(.statusSuccess)
                            
                            Text("Your payment is secure and encrypted")
                                .font(.caption)
                                .foregroundColor(.neutralMedium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.statusSuccess.opacity(0.1))
                        .cornerRadius(12)
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
                .background(Color.neutralBackground)
                
                // Bottom Button
                VStack(spacing: 0) {
                    Divider()
                    
                    Button(action: {
                        Task {
                            viewModel.setBookingData(seat: seat, plan: plan, date: date, userId: "user_1")
                            await viewModel.processPayment()
                        }
                    }) {
                        HStack {
                            if viewModel.isProcessing {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "lock.fill")
                                Text("Pay ₹\(Int(total))")
                            }
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(viewModel.isProcessing)
                    .padding()
                    .background(Color.white)
                }
            }
            
            // Success Overlay
            if viewModel.paymentSuccess {
                paymentSuccessOverlay
            }
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primaryBlue)
                }
                .disabled(viewModel.isProcessing)
            }
        }
        .alert("Payment Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private var paymentSuccessOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.statusSuccess)
                
                Text("Payment Successful!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.neutralDark)
                
                Text("Your seat has been booked successfully.")
                    .font(.subheadline)
                    .foregroundColor(.neutralMedium)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    // Clear navigation stack and go to dashboard
                    navigationManager.goToRoot()
                    navigationManager.navigate(to: .dashboard)
                }) {
                    Text("Go to Dashboard")
                }
                .buttonStyle(PrimaryButtonStyle())
                .frame(width: 200)
            }
            .padding(32)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    NavigationStack {
        PaymentView(
            seat: Seat(seatNumber: "A1", hallId: "1"),
            plan: Plan(name: "Weekly Pass", duration: "7 Days", price: 999, features: ["WiFi"]),
            date: Date()
        )
    }
    .environmentObject(NavigationManager())
}
