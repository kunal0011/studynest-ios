//
//  SeatGridItem.swift
//  studynest
//
//  Individual seat in the grid component
//

import SwiftUI

struct SeatGridItem: View {
    let seat: Seat
    let isSelected: Bool
    let onTap: () -> Void
    
    private var backgroundColor: Color {
        if isSelected {
            return .seatSelected
        } else if seat.isAvailable {
            return .seatAvailable
        } else {
            return .seatOccupied
        }
    }
    
    private var textColor: Color {
        .white
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: "chair.fill")
                    .font(.title2)
                
                Text(seat.seatNumber)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .foregroundColor(textColor)
            .background(backgroundColor)
            .cornerRadius(12)
            .opacity(seat.isAvailable ? 1.0 : 0.6)
        }
        .disabled(!seat.isAvailable)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct SeatLegend: View {
    var body: some View {
        HStack(spacing: 20) {
            LegendItem(color: .seatAvailable, label: "Available")
            LegendItem(color: .seatOccupied, label: "Occupied")
            LegendItem(color: .seatSelected, label: "Selected")
        }
        .padding(.vertical, 8)
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.neutralMedium)
        }
    }
}

#Preview {
    VStack {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
            SeatGridItem(seat: Seat(seatNumber: "A1", hallId: "1", isAvailable: true), isSelected: false) {}
            SeatGridItem(seat: Seat(seatNumber: "A2", hallId: "1", isAvailable: true), isSelected: true) {}
            SeatGridItem(seat: Seat(seatNumber: "A3", hallId: "1", isAvailable: false), isSelected: false) {}
            SeatGridItem(seat: Seat(seatNumber: "A4", hallId: "1", isAvailable: true), isSelected: false) {}
        }
        .padding()
        
        SeatLegend()
    }
    .background(Color.neutralBackground)
}
