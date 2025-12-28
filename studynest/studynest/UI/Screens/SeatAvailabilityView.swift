//
//  SeatAvailabilityView.swift
//  studynest
//
//  Seat selection screen with LazyVGrid seat grid
//

import SwiftUI

struct SeatAvailabilityView: View {
    @StateObject private var viewModel = SeatAvailabilityViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 24) {
                        // Date Picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Date")
                                .font(.headline)
                                .foregroundColor(.neutralDark)
                            
                            DatePicker("", selection: $viewModel.selectedDate, in: Date()..., displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .tint(.primaryBlue)
                                .onChange(of: viewModel.selectedDate) { _, _ in
                                    Task {
                                        await viewModel.dateChanged()
                                    }
                                }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                        
                        // Seat Grid Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Select a Seat")
                                .font(.headline)
                                .foregroundColor(.neutralDark)
                            
                            // Legend
                            SeatLegend()
                            
                            // Seat Grid
                            if case .success(let seats) = viewModel.state {
                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(seats) { seat in
                                        SeatGridItem(
                                            seat: seat,
                                            isSelected: viewModel.selectedSeat?.id == seat.id,
                                            onTap: {
                                                viewModel.selectSeat(seat)
                                            }
                                        )
                                    }
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
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
                .frame(width: geometry.size.width)
                .background(Color.neutralBackground)
                
                // Bottom Button
                if let selectedSeat = viewModel.selectedSeat {
                    VStack(spacing: 0) {
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Selected Seat")
                                    .font(.caption)
                                    .foregroundColor(.neutralMedium)
                                
                                Text(selectedSeat.seatNumber)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primaryBlue)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                navigationManager.navigate(to: .selectPlan(seat: selectedSeat, date: viewModel.selectedDate))
                            }) {
                                Text("Proceed to Plan Selection")
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .frame(width: 200)
                        }
                        .padding()
                        .background(Color.white)
                    }
                }
            }
        }
        .navigationTitle("Select Seat")
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
                await viewModel.loadSeats()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SeatAvailabilityView()
    }
    .environmentObject(NavigationManager())
}
