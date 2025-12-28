//
//  LoginUITests.swift
//  studynestUITests
//
//  UI tests for Login flow
//

import XCTest

final class LoginUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testPhoneLoginUIComponents() throws {
        // Check if StudyNest title exists
        XCTAssertTrue(app.staticTexts["StudyNest"].exists)
        
        // Check if Phone button exists and is selected (default)
        let phoneButton = app.buttons["Phone"]
        XCTAssertTrue(phoneButton.exists)
        
        // Check if +91 text exists (indicating phone mode)
        XCTAssertTrue(app.staticTexts["+91"].exists)
        
        // Check Phone Number text field
        XCTAssertTrue(app.textFields["Phone Number"].exists)
        
        // Check Get OTP button
        XCTAssertTrue(app.buttons["Get OTP"].exists)
    }
    
    func testToggleToEmailLogin() throws {
        // Tap Email button
        let emailButton = app.buttons["Email"]
        XCTAssertTrue(emailButton.exists)
        emailButton.tap()
        
        // Verify Email specific UI appears
        XCTAssertTrue(app.textFields["Email"].exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        
        // Check Login button (instead of Get OTP)
        XCTAssertTrue(app.buttons["Login"].exists)
    }
}
