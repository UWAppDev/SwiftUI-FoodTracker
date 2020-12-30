//
//  Meal.swift
//  FoodTracker
//
//  Copyright © 2020 UWAppDev. All rights reserved.
//

import Foundation
import SwiftUI

/// `struct`s get a default initializer that allows you to initalize each variable with some value.
/// However, because we want to have additional checks for meals, we have to write one ourselves.
struct Meal: Identifiable {
    //In order for meals to be enumerated through a List, a Universally Unique IDentifier is required for each meal
    let id = UUID()
    
    var name: String
    var rating: Int
    var photo: Image?

    /// Constructs an instance of a meal.
    /// - Parameters:
    ///   - name: the name of the meal, must not be empty.
    ///   - rating: an integer between 0 and 5, inclusive.
    ///   - photo: an optional image. Defaults to `nil`.
    init?(name: String, rating: Int, photo: Image? = nil) {
        // The name must not be empty.
        // This is the same as saying:
        //
        //     if name.isEmpty {
        //         return nil
        //     }
        //
        // but guard ensures that we must exit if the condition is not met.
        guard !name.isEmpty else {
            return nil
        }

        // The rating must be between 0 and 5 inclusively.
        // You can also write it as:
        //
        //     guard (0...5).contains(rating)
        //
        // like what we did in `RatingStars`.
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }

        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
