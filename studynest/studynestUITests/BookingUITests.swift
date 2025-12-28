//
//  BookingUITests.swift
//  studynestUITests
//
//  UI tests for Booking flow
//

import XCTest

final class BookingUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
/**
    func testNavigateToBooking() throws {
        // Note: This test assumes we are logged in or can bypass login.
        // For a real app, we might need a launch argument to start in logged-in state.
        // Or we simulate login first.
        
        // For now, let's assume we are at Login.
        // We walk through login quickly to get to Dashboard.
        
        let phoneField = app.textFields["Phone Number"]
        if phoneField.exists {
            phoneField.tap()
            phoneField.typeText("9988776655")
            
            app.buttons["Get OTP"].tap()
            
            let otpField = app.textFields["Enter 6-digit OTP"]
            XCTAssertTrue(otpField.waitForExistence(timeout: 2))
            otpField.tap()
            otpField.typeText("123456")
            
            app.buttons["Verify & Login"].tap()
        }
        
        // Verify Dashboard
        XCTAssertTrue(app.staticTexts["Welcome,"].waitForExistence(timeout: 2))
        
        // Tap Book New Seat
        app.buttons["Book New Seat"].tap()
        
        // Verify Seat Availability Screen
        XCTAssertTrue(app.navigationBars["Select Seat"].exists)
    }
    */
}
