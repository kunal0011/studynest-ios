//
//  AppNavigation.swift
//  studynest
//
//  App navigation routes
//

import SwiftUI
import Combine

enum AppRoute: Hashable {
    case login
    case dashboard
    case seatAvailability
    case selectPlan(seat: Seat, date: Date)
    case checkout(seat: Seat, plan: Plan, date: Date)
    case payment(seat: Seat, plan: Plan, date: Date)
    case bookingHistory
    case profile
    case settings
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .login:
            hasher.combine("login")
        case .dashboard:
            hasher.combine("dashboard")
        case .seatAvailability:
            hasher.combine("seatAvailability")
        case .selectPlan:
            hasher.combine("selectPlan")
        case .checkout:
            hasher.combine("checkout")
        case .payment:
            hasher.combine("payment")
        case .bookingHistory:
            hasher.combine("bookingHistory")
        case .profile:
            hasher.combine("profile")
        case .settings:
            hasher.combine("settings")
        }
    }
    
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.login, .login),
             (.dashboard, .dashboard),
             (.seatAvailability, .seatAvailability),
             (.bookingHistory, .bookingHistory),
             (.profile, .profile),
             (.settings, .settings):
            return true
        case let (.selectPlan(s1, d1), .selectPlan(s2, d2)):
            return s1.id == s2.id && d1 == d2
        case let (.checkout(s1, p1, d1), .checkout(s2, p2, d2)):
            return s1.id == s2.id && p1.id == p2.id && d1 == d2
        case let (.payment(s1, p1, d1), .payment(s2, p2, d2)):
            return s1.id == s2.id && p1.id == p2.id && d1 == d2
        default:
            return false
        }
    }
}

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func goToRoot() {
        path = NavigationPath()
    }
}
