//
//  CheckoutView.swift
//  studynest
//
//  Checkout screen with order summary and price breakdown
//

import SwiftUI

struct CheckoutView: View {
    @StateObject private var viewModel = CheckoutViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    let seat: Seat
    let plan: Plan
    let date: Date
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    // Order Summary
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Order Summary")
                            .font(.headline)
                            .foregroundColor(.neutralDark)
                        
                        // Seat Info
                        HStack {
                            VStack {
                                Image(systemName: "chair.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 50, height: 50)
                            .background(LinearGradient.primaryGradient)
                            .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Seat \(seat.seatNumber)")
                                    .font(.headline)
                                    .foregroundColor(.neutralDark)
                                
                                Text(formattedDate)
                                    .font(.subheadline)
                                    .foregroundColor(.neutralMedium)
                            }
                            
                            Spacer()
                        }
                        
                        Divider()
                        
                        // Plan Info
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(plan.name)
                                    .font(.headline)
                                    .foregroundColor(.neutralDark)
                                
                                Text(plan.duration)
                                    .font(.subheadline)
                                    .foregroundColor(.neutralMedium)
                            }
                            
                            Spacer()
                            
                            Text("₹\(Int(plan.price))")
                                .font(.headline)
                                .foregroundColor(.neutralDark)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                    
                    // Price Breakdown
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Price Details")
                            .font(.headline)
                            .foregroundColor(.neutralDark)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Subtotal")
                                    .foregroundColor(.neutralMedium)
                                Spacer()
                                Text("₹\(Int(viewModel.subtotal))")
                                    .foregroundColor(.neutralDark)
                            }
                            
                            HStack {
                                Text("GST (18%)")
                                    .foregroundColor(.neutralMedium)
                                Spacer()
                                Text("₹\(Int(viewModel.gst))")
                                    .foregroundColor(.neutralDark)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total")
                                    .font(.headline)
                                    .foregroundColor(.neutralDark)
                                Spacer()
                                Text("₹\(Int(viewModel.total))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primaryBlue)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                    
                    // Cancellation Policy
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.primaryBlue)
                            
                            Text("Cancellation Policy")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.neutralDark)
                        }
                        
                        Text("Free cancellation up to 2 hours before your booking starts. After that, a fee of ₹50 will be charged.")
                            .font(.caption)
                            .foregroundColor(.neutralMedium)
                    }
                    .padding()
                    .background(Color.primaryBlue.opacity(0.05))
                    .cornerRadius(12)
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .background(Color.neutralBackground)
            
            // Bottom Button
            VStack(spacing: 0) {
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Amount")
                            .font(.caption)
                            .foregroundColor(.neutralMedium)
                        
                        Text("₹\(Int(viewModel.total))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryBlue)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        navigationManager.navigate(to: .payment(seat: seat, plan: plan, date: date))
                    }) {
                        Text("Proceed to Payment")
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .frame(width: 180)
                }
                .padding()
                .background(Color.white)
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primaryBlue)
                }
            }
        }
        .onAppear {
            viewModel.setCheckoutData(seat: seat, plan: plan, date: date)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        CheckoutView(
            seat: Seat(seatNumber: "A1", hallId: "1"),
            plan: Plan(name: "Weekly Pass", duration: "7 Days", price: 999, features: ["WiFi"]),
            date: Date()
        )
    }
    .environmentObject(NavigationManager())
}
