//
//  PlanCard.swift
//  studynest
//
//  Subscription plan card component
//

import SwiftUI

struct PlanCard: View {
    let plan: Plan
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with badge
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.neutralDark)
                    
                    Text(plan.duration)
                        .font(.subheadline)
                        .foregroundColor(.neutralMedium)
                }
                
                Spacer()
                
                if plan.isRecommended {
                    Text("RECOMMENDED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondaryOrange)
                        .cornerRadius(4)
                }
            }
            
            // Price
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("₹")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryBlue)
                
                Text("\(Int(plan.price))")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primaryBlue)
            }
            
            // Divider
            Rectangle()
                .fill(Color.neutralLight)
                .frame(height: 1)
            
            // Features
            VStack(alignment: .leading, spacing: 8) {
                ForEach(plan.features, id: \.self) { feature in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.statusSuccess)
                        
                        Text(feature)
                            .font(.subheadline)
                            .foregroundColor(.neutralMedium)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.primaryBlue : Color.neutralLight, lineWidth: isSelected ? 2 : 1)
        )
        .shadow(color: isSelected ? Color.primaryBlue.opacity(0.2) : Color.black.opacity(0.06), radius: isSelected ? 12 : 8, x: 0, y: 4)
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            PlanCard(
                plan: Plan(name: "Weekly Pass", duration: "7 Days", price: 999, features: ["WiFi", "Locker", "Coffee"], isRecommended: true),
                isSelected: true
            ) {}
            
            PlanCard(
                plan: Plan(name: "Daily Pass", duration: "1 Day", price: 199, features: ["WiFi", "Power"], isRecommended: false),
                isSelected: false
            ) {}
        }
        .padding()
    }
    .background(Color.neutralBackground)
}
