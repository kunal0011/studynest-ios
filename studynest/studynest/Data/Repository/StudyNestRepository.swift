//
//  StudyNestRepository.swift
//  studynest
//
//  Repository for data access with mock data
//

import Foundation
import SwiftData
import Combine

@MainActor
class StudyNestRepository: ObservableObject {
    private let modelContext: ModelContext?
    
     init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    // MARK: - Authentication
    
    func login(email: String, password: String) async -> LoginResponse {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock successful login
        let user = User(
            name: "John Doe",
            email: email,
            phone: "+91 9876543210",
            profileUrl: nil
        )
        
        return LoginResponse(
            success: true,
            user: user,
            message: "Login successful",
            token: "mock_token_\(UUID().uuidString)"
        )
    }
    
    func loginWithOTP(phone: String, otp: String) async -> LoginResponse {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock OTP verification
        if !otp.isEmpty {
            let user = User(
                name: "John Doe",
                email: "john@example.com",
                phone: phone,
                profileUrl: nil
            )
            
            return LoginResponse(
                success: true,
                user: user,
                message: "OTP verified successfully",
                token: "mock_token_\(UUID().uuidString)"
            )
        } else {
            return LoginResponse(
                success: false,
                user: nil,
                message: "Invalid OTP. Please try again.",
                token: nil
            )
        }
    }
    
    func sendOTP(phone: String) async -> Bool {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    // MARK: - Dashboard
    
    func getDashboardStats() async -> DashboardStats {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        return DashboardStats(
            hoursThisWeek: 24,
            totalHours: 156,
            currentStreak: 7,
            bookingsThisMonth: 12
        )
    }
    
    func getCurrentBooking(userId: String) async -> Booking? {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Mock current active booking
        return Booking(
            seatId: "seat_1",
            seatNumber: "A1",
            userId: userId,
            startTime: Date(),
            endTime: Calendar.current.date(byAdding: .hour, value: 4, to: Date()) ?? Date(),
            status: .active,
            planName: "Daily Pass",
            totalAmount: 199.0
        )
    }
    
    // MARK: - Seats
    
    func getSeats(date: Date, hallId: String) async -> [Seat] {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Generate 4x4 grid of seats (16 seats)
        var seats: [Seat] = []
        let rows = ["A", "B", "C", "D"]
        
        for (rowIndex, row) in rows.enumerated() {
            for col in 1...4 {
                let seatNumber = "\(row)\(col)"
                // Randomly mark some seats as occupied
                let isAvailable = !(rowIndex == 1 && col == 2) && !(rowIndex == 2 && col == 3) && !(rowIndex == 0 && col == 4)
                
                seats.append(Seat(
                    seatNumber: seatNumber,
                    hallId: hallId,
                    isAvailable: isAvailable,
                    price: 50.0
                ))
            }
        }
        
        return seats
    }
    
    // MARK: - Plans
    
    func getPlans() async -> [Plan] {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        return [
            Plan(
                name: "Daily Pass",
                duration: "1 Day",
                price: 199.0,
                features: [
                    "Access for 1 day",
                    "High-speed WiFi",
                    "Power outlet"
                ],
                isRecommended: false
            ),
            Plan(
                name: "Weekly Pass",
                duration: "7 Days",
                price: 999.0,
                features: [
                    "Access for 7 days",
                    "High-speed WiFi",
                    "Power outlet",
                    "Locker access",
                    "Free coffee"
                ],
                isRecommended: true
            ),
            Plan(
                name: "Monthly Pass",
                duration: "30 Days",
                price: 2999.0,
                features: [
                    "Access for 30 days",
                    "High-speed WiFi",
                    "Power outlet",
                    "Locker access",
                    "Free beverages",
                    "Meeting room (2 hrs/week)"
                ],
                isRecommended: false
            )
        ]
    }
    
    // MARK: - Bookings
    
    func syncBookings(userId: String) async -> [Booking] {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Mock booking history
        let now = Date()
        let calendar = Calendar.current
        
        return [
            Booking(
                seatId: "seat_1",
                seatNumber: "A1",
                userId: userId,
                startTime: calendar.date(byAdding: .day, value: -1, to: now) ?? now,
                endTime: calendar.date(byAdding: .hour, value: 4, to: calendar.date(byAdding: .day, value: -1, to: now) ?? now) ?? now,
                status: .completed,
                planName: "Daily Pass",
                totalAmount: 199.0
            ),
            Booking(
                seatId: "seat_5",
                seatNumber: "B1",
                userId: userId,
                startTime: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
                endTime: calendar.date(byAdding: .hour, value: 8, to: calendar.date(byAdding: .day, value: -3, to: now) ?? now) ?? now,
                status: .completed,
                planName: "Weekly Pass",
                totalAmount: 999.0
            ),
            Booking(
                seatId: "seat_10",
                seatNumber: "C2",
                userId: userId,
                startTime: calendar.date(byAdding: .day, value: -7, to: now) ?? now,
                endTime: calendar.date(byAdding: .hour, value: 6, to: calendar.date(byAdding: .day, value: -7, to: now) ?? now) ?? now,
                status: .cancelled,
                planName: "Daily Pass",
                totalAmount: 199.0
            )
        ]
    }
    
    func createBooking(_ booking: Booking) async -> Bool {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Save to SwiftData if context is available
        if let context = modelContext {
            let entity = BookingEntity(
                id: booking.id,
                seatId: booking.seatId,
                seatNumber: booking.seatNumber,
                userId: booking.userId,
                startTime: booking.startTime,
                endTime: booking.endTime,
                status: booking.status.rawValue,
                planName: booking.planName,
                totalAmount: booking.totalAmount
            )
            context.insert(entity)
            try? context.save()
        }
        
        return true
    }
    
    // MARK: - User
    
    func saveUser(_ user: User) {
        guard let context = modelContext else { return }
        
        let entity = UserEntity(
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            profileUrl: user.profileUrl
        )
        context.insert(entity)
        try? context.save()
    }
    
    func getStoredUser() -> User? {
        guard let context = modelContext else { return nil }
        
        let descriptor = FetchDescriptor<UserEntity>()
        let users = try? context.fetch(descriptor)
        return users?.first?.toUser()
    }
    
    func logout() {
        guard let context = modelContext else { return }
        
        // Delete all users
        let descriptor = FetchDescriptor<UserEntity>()
        if let users = try? context.fetch(descriptor) {
            for user in users {
                context.delete(user)
            }
            try? context.save()
        }
    }
}
