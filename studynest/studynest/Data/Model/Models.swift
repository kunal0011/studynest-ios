//
//  Models.swift
//  studynest
//
//  Data models for StudyNest iOS app
//

import Foundation
import SwiftData

// MARK: - ViewState
enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case error(String)
}

// MARK: - User
struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let phone: String?
    let profileUrl: String?
    
    init(id: String = UUID().uuidString, name: String, email: String, phone: String? = nil, profileUrl: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.profileUrl = profileUrl
    }
}

// MARK: - Seat
struct Seat: Codable, Identifiable {
    let id: String
    let seatNumber: String
    let hallId: String
    let isAvailable: Bool
    let price: Double
    
    init(id: String = UUID().uuidString, seatNumber: String, hallId: String, isAvailable: Bool = true, price: Double = 50.0) {
        self.id = id
        self.seatNumber = seatNumber
        self.hallId = hallId
        self.isAvailable = isAvailable
        self.price = price
    }
}

// MARK: - Booking
struct Booking: Codable, Identifiable {
    let id: String
    let seatId: String
    let seatNumber: String
    let userId: String
    let startTime: Date
    let endTime: Date
    let status: BookingStatus
    let planName: String
    let totalAmount: Double
    
    init(id: String = UUID().uuidString, seatId: String, seatNumber: String, userId: String, startTime: Date, endTime: Date, status: BookingStatus = .active, planName: String, totalAmount: Double) {
        self.id = id
        self.seatId = seatId
        self.seatNumber = seatNumber
        self.userId = userId
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
        self.planName = planName
        self.totalAmount = totalAmount
    }
}

enum BookingStatus: String, Codable {
    case active = "ACTIVE"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
    case upcoming = "UPCOMING"
}

// MARK: - Plan
struct Plan: Codable, Identifiable {
    let id: String
    let name: String
    let duration: String
    let price: Double
    let features: [String]
    let isRecommended: Bool
    
    init(id: String = UUID().uuidString, name: String, duration: String, price: Double, features: [String], isRecommended: Bool = false) {
        self.id = id
        self.name = name
        self.duration = duration
        self.price = price
        self.features = features
        self.isRecommended = isRecommended
    }
}

// MARK: - Login Response
struct LoginResponse: Codable {
    let success: Bool
    let user: User?
    let message: String?
    let token: String?
}

// MARK: - Dashboard Stats
struct DashboardStats: Codable {
    let hoursThisWeek: Int
    let totalHours: Int
    let currentStreak: Int
    let bookingsThisMonth: Int
}

// MARK: - Payment Method
enum PaymentMethod: String, CaseIterable, Identifiable {
    case card = "Credit/Debit Card"
    case upi = "UPI"
    case netBanking = "Net Banking"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .card: return "creditcard.fill"
        case .upi: return "indianrupeesign.circle.fill"
        case .netBanking: return "building.columns.fill"
        }
    }
}

// MARK: - SwiftData Models

@Model
final class UserEntity {
    @Attribute(.unique) var id: String
    var name: String
    var email: String
    var phone: String?
    var profileUrl: String?
    
    init(id: String = UUID().uuidString, name: String, email: String, phone: String? = nil, profileUrl: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.profileUrl = profileUrl
    }
    
    func toUser() -> User {
        User(id: id, name: name, email: email, phone: phone, profileUrl: profileUrl)
    }
}

@Model
final class BookingEntity {
    @Attribute(.unique) var id: String
    var seatId: String
    var seatNumber: String
    var userId: String
    var startTime: Date
    var endTime: Date
    var status: String
    var planName: String
    var totalAmount: Double
    
    init(id: String = UUID().uuidString, seatId: String, seatNumber: String, userId: String, startTime: Date, endTime: Date, status: String, planName: String, totalAmount: Double) {
        self.id = id
        self.seatId = seatId
        self.seatNumber = seatNumber
        self.userId = userId
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
        self.planName = planName
        self.totalAmount = totalAmount
    }
    
    func toBooking() -> Booking {
        Booking(
            id: id,
            seatId: seatId,
            seatNumber: seatNumber,
            userId: userId,
            startTime: startTime,
            endTime: endTime,
            status: BookingStatus(rawValue: status) ?? .active,
            planName: planName,
            totalAmount: totalAmount
        )
    }
}
