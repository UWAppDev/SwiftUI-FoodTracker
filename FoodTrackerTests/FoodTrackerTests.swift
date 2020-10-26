//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Copyright © 2020 UWAppDev. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    // MARK: - Meal Class Tests

    /// Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testMealInitializationSucceeds() {
        // Zero rating
        let zeroRatingMeal = Meal(name: "Zero", rating: 0)
        XCTAssertNotNil(zeroRatingMeal)

        // Highest positive rating
        let positiveRatingMeal = Meal(name: "Positive", rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }

    /// Confirm that the Meal initialier returns nil when passed a negative rating or an empty name.
    func testMealInitializationFails() {
        // Negative rating
        let negativeRatingMeal = Meal(name: "Negative", rating: -1)
        XCTAssertNil(negativeRatingMeal)

        // Rating exceeds maximum
        let largeRatingMeal = Meal(name: "Large", rating: 6)
        XCTAssertNil(largeRatingMeal)

        // Empty String
        let emptyStringMeal = Meal(name: "", rating: 0)
        XCTAssertNil(emptyStringMeal)
    }
}
