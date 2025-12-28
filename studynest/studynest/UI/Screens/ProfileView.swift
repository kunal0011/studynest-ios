//
//  ProfileView.swift
//  studynest
//
//  User profile screen with avatar and logout
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var showLogoutAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 16) {
                    // Avatar
                    Circle()
                        .fill(LinearGradient.primaryGradient)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(String(viewModel.currentUser?.name.prefix(1) ?? "U"))
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .shadow(color: Color.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    // Name
                    Text(viewModel.currentUser?.name ?? "User")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.neutralDark)
                    
                    // Email
                    Text(viewModel.currentUser?.email ?? "")
                        .font(.subheadline)
                        .foregroundColor(.neutralMedium)
                    
                    // Phone
                    if let phone = viewModel.currentUser?.phone {
                        Text(phone)
                            .font(.subheadline)
                            .foregroundColor(.neutralMedium)
                    }
                }
                .padding(.vertical, 32)
                
                // Profile Options
                VStack(spacing: 0) {
                    ProfileMenuItem(
                        icon: "person.circle.fill",
                        title: "Edit Profile",
                        color: .primaryBlue
                    ) {
                        // TODO: Navigate to edit profile
                    }
                    
                    Divider()
                        .padding(.leading, 56)
                    
                    ProfileMenuItem(
                        icon: "bell.fill",
                        title: "Notifications",
                        color: .secondaryOrange
                    ) {
                        // TODO: Navigate to notifications
                    }
                    
                    Divider()
                        .padding(.leading, 56)
                    
                    ProfileMenuItem(
                        icon: "questionmark.circle.fill",
                        title: "Help & Support",
                        color: .secondaryTeal
                    ) {
                        // TODO: Navigate to help
                    }
                    
                    Divider()
                        .padding(.leading, 56)
                    
                    ProfileMenuItem(
                        icon: "doc.text.fill",
                        title: "Terms & Conditions",
                        color: .neutralMedium
                    ) {
                        // TODO: Navigate to terms
                    }
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                
                // Logout Button
                Button(action: {
                    showLogoutAlert = true
                }) {
                    HStack {
                        Image(systemName: "arrow.right.square.fill")
                        Text("Logout")
                    }
                    .foregroundColor(.statusError)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.statusError.opacity(0.1))
                .cornerRadius(12)
                
                // App Version
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.neutralMedium)
                    .padding(.top, 16)
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .background(Color.neutralBackground)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                viewModel.logout()
                navigationManager.goToRoot()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.neutralDark)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.neutralLight)
            }
            .padding()
        }
    }
}

#Preview {
    ProfileView(viewModel: DashboardViewModel())
        .environmentObject(NavigationManager())
}
