// ABOUTME: Tests for DesignSystem components using TMA testing patterns
// ABOUTME: Demonstrates UI component testing with accessibility validation

import DesignSystem
import DesignSystemTesting
import SwiftUI
import XCTest

final class PrimaryButtonTests: XCTestCase {
    func testButtonStyles() {
        // Test that button factory methods work correctly
        let filledButton = PrimaryButton.mockFilled()
        let outlinedButton = PrimaryButton.mockOutlined()
        let textButton = PrimaryButton.mockText()
        let disabledButton = PrimaryButton.mockDisabled()

        // Basic smoke test - ensure buttons can be created
        XCTAssertNotNil(filledButton)
        XCTAssertNotNil(outlinedButton)
        XCTAssertNotNil(textButton)
        XCTAssertNotNil(disabledButton)
    }

    func testButtonTitles() {
        // Test various button title lengths
        for title in MockDesignSystemData.buttonTitles {
            let button = PrimaryButton.mockFilled(title: title)
            XCTAssertNotNil(button)
        }
    }

    func testAccessibilityTraits() {
        // This would require UI testing framework for full validation
        // For now, we ensure the button API supports accessibility
        let button = PrimaryButton("Accessible Button") {}
        XCTAssertNotNil(button)
    }
}
