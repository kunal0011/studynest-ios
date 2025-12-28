//
//  SelectPlanView.swift
//  studynest
//
//  Plan selection screen with plan cards
//

import SwiftUI

struct SelectPlanView: View {
    @StateObject private var viewModel = SelectPlanViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    let seat: Seat
    let date: Date
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            LazyVStack(spacing: 20) {
                // Header Info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "chair.fill")
                            .foregroundColor(.primaryBlue)
                        
                        Text("Seat \(seat.seatNumber)")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(formattedDate)
                            .font(.subheadline)
                            .foregroundColor(.neutralMedium)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                
                // Plan Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Choose Your Plan")
                        .font(.headline)
                        .foregroundColor(.neutralDark)
                    
                    if case .success(let plans) = viewModel.state {
                        ForEach(plans) { plan in
                            PlanCard(
                                plan: plan,
                                isSelected: viewModel.selectedPlan?.id == plan.id,
                                onTap: {
                                    viewModel.selectPlan(plan)
                                }
                            )
                        }
                    } else if case .loading = viewModel.state {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
            .padding()
            // Add extra bottom padding when bottom action bar is present
            .padding(.bottom, viewModel.selectedPlan != nil ? 100 : 24)
        }
        .scrollBounceBehavior(.basedOnSize)
        // Reserve bottom space for the action bar so content is never hidden behind it
        .safeAreaInset(edge: .bottom) {
            if let selectedPlan = viewModel.selectedPlan {
                VStack(spacing: 0) {
                    Divider()

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(selectedPlan.name)
                                .font(.headline)
                                .foregroundColor(.neutralDark)
                            
                            Text("₹\(Int(selectedPlan.price))")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryBlue)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            navigationManager.navigate(to: .checkout(seat: seat, plan: selectedPlan, date: date))
                        }) {
                            Text("Proceed to Checkout")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .frame(width: 180)
                    }
                    .padding()
                    .background(Color.white)
                }
            }
        }
        // Move background to the outer container so it fills full screen
        .background(Color.neutralBackground.ignoresSafeArea())
        .navigationTitle("Select Plan")
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
            Task {
                await viewModel.loadPlans()
            }
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
        SelectPlanView(
            seat: Seat(seatNumber: "A1", hallId: "1"),
            date: Date()
        )
    }
    .environmentObject(NavigationManager())
}
