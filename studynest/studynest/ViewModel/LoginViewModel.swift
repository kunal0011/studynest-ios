//
//  LoginViewModel.swift
//  studynest
//
//  ViewModel for login functionality
//

import Foundation
import SwiftUI
import Combine

enum LoginMode {
    case phone
    case email
}

@MainActor
class LoginViewModel: ObservableObject {
    @Published var loginMode: LoginMode = .phone
    @Published var phoneNumber: String = ""
    @Published var otp: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isOtpSent: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    
    private let repository: StudyNestRepository
    
    init(repository: StudyNestRepository? = nil) {
        self.repository = repository ?? StudyNestRepository()
    }
    
    func sendOTP() async {
        guard !phoneNumber.isEmpty else {
            errorMessage = "Please enter a phone number"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let success = await repository.sendOTP(phone: phoneNumber)
        
        isLoading = false
        if success {
            isOtpSent = true
        } else {
            errorMessage = "Failed to send OTP. Please try again."
        }
    }
    
    func verifyOTP() async {
        guard !otp.isEmpty else {
            errorMessage = "Please enter the OTP"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let response = await repository.loginWithOTP(phone: phoneNumber, otp: otp)
        
        isLoading = false
        if response.success, let user = response.user {
            currentUser = user
            repository.saveUser(user)
            isLoggedIn = true
        } else {
            errorMessage = response.message ?? "Invalid OTP"
        }
    }
    
    func loginWithEmail() async {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Please enter your password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let response = await repository.login(email: email, password: password)
        
        isLoading = false
        if response.success, let user = response.user {
            currentUser = user
            repository.saveUser(user)
            isLoggedIn = true
        } else {
            errorMessage = response.message ?? "Login failed"
        }
    }
    
    func loginWithGoogle() async {
        // Mock Google sign-in
        isLoading = true
        errorMessage = nil
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let user = User(
            name: "Google User",
            email: "google.user@gmail.com",
            phone: nil,
            profileUrl: nil
        )
        
        isLoading = false
        currentUser = user
        repository.saveUser(user)
        isLoggedIn = true
    }
    
    func toggleLoginMode() {
        loginMode = loginMode == .phone ? .email : .phone
        errorMessage = nil
    }
    
    func resetOTP() {
        isOtpSent = false
        otp = ""
    }
    
    /// Resets all login state - call after successful login navigation
    func resetLoginState() {
        phoneNumber = ""
        otp = ""
        email = ""
        password = ""
        isOtpSent = false
        isLoading = false
        errorMessage = nil
        isLoggedIn = false
    }
}
