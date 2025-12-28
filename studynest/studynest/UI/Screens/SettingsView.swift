//
//  SettingsView.swift
//  studynest
//
//  Settings screen with toggles and options
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var emailNotifications = true
    @State private var pushNotifications = true
    @State private var darkMode = false
    
    var body: some View {
        List {
            // Notifications Section
            Section {
                Toggle(isOn: $notificationsEnabled) {
                    HStack(spacing: 12) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.primaryBlue)

                        Text("Enable Notifications")
                    }
                }
                .tint(.primaryBlue)

                if notificationsEnabled {
                    Toggle(isOn: $pushNotifications) {
                        HStack(spacing: 12) {
                            Image(systemName: "iphone.radiowaves.left.and.right")
                                .foregroundColor(.secondaryTeal)

                            Text("Push Notifications")
                        }
                    }
                    .tint(.primaryBlue)

                    Toggle(isOn: $emailNotifications) {
                        HStack(spacing: 12) {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.secondaryOrange)

                            Text("Email Notifications")
                        }
                    }
                    .tint(.primaryBlue)
                }
            } header: {
                Text("Notifications")
            }

            // Appearance Section
            Section {
                Toggle(isOn: $darkMode) {
                    HStack(spacing: 12) {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.purple)

                        Text("Dark Mode")
                    }
                }
                .tint(.primaryBlue)
            } header: {
                Text("Appearance")
            }

            // About Section
            Section {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.primaryBlue)

                    Text("About StudyNest")

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.neutralLight)
                }

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.secondaryOrange)

                    Text("Rate Us")

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.neutralLight)
                }

                HStack {
                    Image(systemName: "square.and.arrow.up.fill")
                        .foregroundColor(.secondaryTeal)

                    Text("Share App")

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.neutralLight)
                }
            } header: {
                Text("About")
            }

            // Legal Section
            Section {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.neutralMedium)

                    Text("Privacy Policy")

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.neutralLight)
                }

                HStack {
                    Image(systemName: "doc.plaintext.fill")
                        .foregroundColor(.neutralMedium)

                    Text("Terms of Service")

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.neutralLight)
                }
            } header: {
                Text("Legal")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
