//
//  StatCard.swift
//  studynest
//
//  Dashboard stat display card component
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.neutralDark)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.neutralMedium)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    HStack {
        StatCard(title: "Hours This Week", value: "24", icon: "clock.fill", color: .primaryBlue)
        StatCard(title: "Total Hours", value: "156", icon: "chart.bar.fill", color: .secondaryTeal)
    }
    .padding()
    .background(Color.neutralBackground)
}
