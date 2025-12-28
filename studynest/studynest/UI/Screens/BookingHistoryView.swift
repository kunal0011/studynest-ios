//
//  BookingHistoryView.swift
//  studynest
//
//  Booking history screen with past bookings
//

import SwiftUI

struct BookingHistoryView: View {
    @ObservedObject var viewModel: BookingHistoryViewModel
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                VStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("Loading bookings...")
                        .font(.subheadline)
                        .foregroundColor(.neutralMedium)
                        .padding(.top, 8)
                    Spacer()
                }
                
            case .success(let bookings):
                if bookings.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(bookings) { booking in
                                BookingCard(booking: booking)
                            }
                        }
                        .padding()
                    }
                }
                
            case .error(let message):
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 50))
                    .foregroundColor(.statusError)
                
                Text("Error")
                    .font(.headline)
                    .foregroundColor(.neutralDark)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.neutralMedium)
                    .multilineTextAlignment(.center)
                
                Button("Retry") {
                    Task {
                        await viewModel.loadBookings(userId: "user_1")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .frame(width: 120)
            }
            .padding()
        }
    }
    .background(Color.neutralBackground)
    .navigationTitle("Booking History")
    .navigationBarTitleDisplayMode(.inline)
}
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 60))
                .foregroundColor(.neutralLight)
            
            Text("No Bookings Yet")
                .font(.headline)
                .foregroundColor(.neutralDark)
            
            Text("Your booking history will appear here once you book a seat.")
                .font(.subheadline)
                .foregroundColor(.neutralMedium)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    BookingHistoryView(viewModel: BookingHistoryViewModel())
}
