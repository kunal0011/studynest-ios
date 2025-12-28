//
//  LoginView.swift
//  studynest
//
//  Login screen with Mobile OTP, Email/Password, and Google SSO
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.primaryBlue, Color.primaryDark]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Logo and Title
                    VStack(spacing: 12) {
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        
                        Text("StudyNest")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Your study space, simplified")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 40)
                    
                    // Login Card
                    VStack(spacing: 20) {
                        // Mode Toggle
                        HStack {
                            Button(action: {
                                if viewModel.loginMode != .phone {
                                    viewModel.toggleLoginMode()
                                }
                            }) {
                                Text("Phone")
                                    .font(.headline)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.loginMode == .phone ? Color.primaryBlue : Color.clear)
                                    .foregroundColor(viewModel.loginMode == .phone ? .white : .neutralMedium)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                if viewModel.loginMode != .email {
                                    viewModel.toggleLoginMode()
                                }
                            }) {
                                Text("Email")
                                    .font(.headline)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.loginMode == .email ? Color.primaryBlue : Color.clear)
                                    .foregroundColor(viewModel.loginMode == .email ? .white : .neutralMedium)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(4)
                        .background(Color.neutralLight)
                        .cornerRadius(12)
                        
                        // Input Fields
                        if viewModel.loginMode == .phone {
                            phoneLoginView
                        } else {
                            emailLoginView
                        }
                        
                        // Error Message
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.statusError)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color.neutralLight)
                                .frame(height: 1)
                            
                            Text("or")
                                .font(.caption)
                                .foregroundColor(.neutralMedium)
                            
                            Rectangle()
                                .fill(Color.neutralLight)
                                .frame(height: 1)
                        }
                        
                        // Google Sign In
                        Button(action: {
                            Task {
                                await viewModel.loginWithGoogle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "g.circle.fill")
                                    .font(.title2)
                                
                                Text("Continue with Google")
                                    .fontWeight(.medium)
                            }
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            
            // Loading Overlay
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
            }
        }
        .onChange(of: viewModel.isLoggedIn) { _, isLoggedIn in
            if isLoggedIn {
                navigationManager.navigate(to: .dashboard)
                // Reset login state so returning shows phone number input
                viewModel.resetLoginState()
            }
        }
    }
    
    // MARK: - Phone Login View
    private var phoneLoginView: some View {
        VStack(spacing: 16) {
            if !viewModel.isOtpSent {
                // Phone Number Input
                HStack {
                    Text("+91")
                        .foregroundColor(.neutralMedium)
                    
                    TextField("Phone Number", text: $viewModel.phoneNumber)
                        .keyboardType(.phonePad)
                }
                .padding()
                .background(Color.neutralBackground)
                .cornerRadius(12)
                
                Button(action: {
                    Task {
                        await viewModel.sendOTP()
                    }
                }) {
                    Text("Get OTP")
                }
                .buttonStyle(PrimaryButtonStyle())
            } else {
                // OTP Input
                Text("Enter OTP sent to +91 \(viewModel.phoneNumber)")
                    .font(.subheadline)
                    .foregroundColor(.neutralMedium)
                
                TextField("Enter 6-digit OTP", text: $viewModel.otp)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .padding()
                    .background(Color.neutralBackground)
                    .cornerRadius(12)
                
                Button(action: {
                    Task {
                        await viewModel.verifyOTP()
                    }
                }) {
                    Text("Verify & Login")
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button(action: {
                    viewModel.resetOTP()
                }) {
                    Text("Change Number")
                        .font(.subheadline)
                        .foregroundColor(.primaryBlue)
                }
            }
        }
    }
    
    // MARK: - Email Login View
    private var emailLoginView: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.neutralBackground)
                .cornerRadius(12)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.neutralBackground)
                .cornerRadius(12)
            
            Button(action: {
                Task {
                    await viewModel.loginWithEmail()
                }
            }) {
                Text("Login")
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(NavigationManager())
}
