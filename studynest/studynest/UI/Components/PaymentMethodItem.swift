//
//  PaymentMethodItem.swift
//  studynest
//
//  Payment option row component
//

import SwiftUI

struct PaymentMethodItem: View {
    let method: PaymentMethod
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: method.icon)
                    .font(.title2)
                    .foregroundColor(.primaryBlue)
                    .frame(width: 40)
                
                // Label
                Text(method.rawValue)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.neutralDark)
                
                Spacer()
                
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .primaryBlue : .neutralLight)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.primaryBlue : Color.neutralLight, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    VStack(spacing: 12) {
        PaymentMethodItem(method: .card, isSelected: true) {}
        PaymentMethodItem(method: .upi, isSelected: false) {}
        PaymentMethodItem(method: .netBanking, isSelected: false) {}
    }
    .padding()
    .background(Color.neutralBackground)
}
