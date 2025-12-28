//
//  BookingCard.swift
//  studynest
//
//  Booking history item component
//

import SwiftUI

struct BookingCard: View {
    let booking: Booking
    
    private var statusColor: Color {
        switch booking.status {
        case .active:
            return .statusSuccess
        case .completed:
            return .primaryBlue
        case .cancelled:
            return .statusError
        case .upcoming:
            return .secondaryOrange
        }
    }
    
    private var statusText: String {
        booking.status.rawValue
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: booking.startTime)
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let start = formatter.string(from: booking.startTime)
        let end = formatter.string(from: booking.endTime)
        return "\(start) - \(end)"
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Seat icon
            VStack {
                Image(systemName: "chair.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .frame(width: 50, height: 50)
            .background(LinearGradient.primaryGradient)
            .cornerRadius(12)
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text("Seat \(booking.seatNumber)")
                    .font(.headline)
                    .foregroundColor(.neutralDark)
                
                Text(formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.neutralMedium)
                
                Text(formattedTime)
                    .font(.caption)
                    .foregroundColor(.neutralMedium)
            }
            
            Spacer()
            
            // Status and price
            VStack(alignment: .trailing, spacing: 4) {
                Text(statusText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor)
                    .cornerRadius(4)
                
                Text("₹\(Int(booking.totalAmount))")
                    .font(.headline)
                    .foregroundColor(.neutralDark)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    VStack(spacing: 16) {
        BookingCard(booking: Booking(
            seatId: "1",
            seatNumber: "A1",
            userId: "user1",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600 * 4),
            status: .active,
            planName: "Daily Pass",
            totalAmount: 199
        ))
        
        BookingCard(booking: Booking(
            seatId: "2",
            seatNumber: "B2",
            userId: "user1",
            startTime: Date().addingTimeInterval(-86400),
            endTime: Date().addingTimeInterval(-86400 + 3600 * 4),
            status: .completed,
            planName: "Weekly Pass",
            totalAmount: 999
        ))
    }
    .padding()
    .background(Color.neutralBackground)
}
