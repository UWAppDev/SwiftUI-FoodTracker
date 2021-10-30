//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Apollo Zhu on 10/30/21.
//  Copyright © 2021 AppDev@UW.edu. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    // NOTE: we got rid of the template code

    // MARK: - Meal Class Tests
    
    /// Confirm that the Meal initializer returns a Meal instance
    /// when passed valid parameters.
    func testMealInitializationSucceeds() {
        // Zero rating
        let zeroRatingMeal = Meal(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
         
        // Highest positive rating
        let positiveRatingMeal = Meal(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }

    /// Confirm that the Meal initializer returns nil
    /// when passed a negative rating or an empty name.
    func testMealInitializationFails() {
        // Negative rating
        let negativeRatingMeal = Meal(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
         
        // Empty String
        let emptyStringMeal = Meal(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
        
        // NOTE: maybe encourage students to think about this edges cases:
        // or maybe any of the scenarios that shouldn't work.
        // This helps the to think about how they should test their own code.
        // Rating exceeds maximum
        let largeRatingMeal = Meal(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
    }
}
