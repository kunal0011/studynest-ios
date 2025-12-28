//
//  HomeContentView.swift
//  studynest
//
//  Home tab content with current booking, stats, and book button
//

import SwiftUI

struct HomeContentView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Welcome Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome back,")
                            .font(.subheadline)
                            .foregroundColor(.neutralMedium)
                        
                        Text(viewModel.currentUser?.name ?? "User")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.neutralDark)
                    }
                    
                    Spacer()
                    
                    Circle()
                        .fill(LinearGradient.primaryGradient)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(String(viewModel.currentUser?.name.prefix(1) ?? "U"))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
                .padding(.horizontal)
                
                // Current Booking Card
                if let booking = viewModel.currentBooking {
                    currentBookingCard(booking)
                } else {
                    noBookingCard
                }
                
                // Stats Section
                statsSection
                
                // Book New Seat Button
                Button(action: {
                    navigationManager.navigate(to: .seatAvailability)
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Book New Seat")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
            .padding(.top)
        }
        .background(Color.neutralBackground)
        .navigationTitle("StudyNest")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Current Booking Card
    private func currentBookingCard(_ booking: Booking) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Current Booking")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(booking.status.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Seat")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(booking.seatNumber)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Divider()
                    .frame(height: 40)
                    .background(Color.white.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Time Remaining")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(timeRemaining(from: booking.endTime))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(LinearGradient.primaryGradient)
        .cornerRadius(20)
        .shadow(color: Color.primaryBlue.opacity(0.3), radius: 15, x: 0, y: 8)
        .padding(.horizontal)
    }
    
    private var noBookingCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40))
                .foregroundColor(.primaryBlue)
            
            Text("No Active Booking")
                .font(.headline)
                .foregroundColor(.neutralDark)
            
            Text("Book a seat to start studying")
                .font(.subheadline)
                .foregroundColor(.neutralMedium)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Stats")
                .font(.headline)
                .foregroundColor(.neutralDark)
                .padding(.horizontal)
            
            if case .success(let stats) = viewModel.state {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    StatCard(title: "Hours This Week", value: "\(stats.hoursThisWeek)", icon: "clock.fill", color: .primaryBlue)
                    StatCard(title: "Total Hours", value: "\(stats.totalHours)", icon: "chart.bar.fill", color: .secondaryTeal)
                    StatCard(title: "Current Streak", value: "\(stats.currentStreak) days", icon: "flame.fill", color: .secondaryOrange)
                    StatCard(title: "This Month", value: "\(stats.bookingsThisMonth) bookings", icon: "calendar", color: .primaryLight)
                }
                .padding(.horizontal)
            } else if case .loading = viewModel.state {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    // MARK: - Helpers
    private func timeRemaining(from endTime: Date) -> String {
        let interval = endTime.timeIntervalSince(Date())
        if interval <= 0 {
            return "Completed"
        }
        
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes) min"
        }
    }
}

#Preview {
    HomeContentView(viewModel: DashboardViewModel())
        .environmentObject(NavigationManager())
}
