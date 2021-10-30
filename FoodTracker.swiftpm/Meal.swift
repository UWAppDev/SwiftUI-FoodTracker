//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftUI FoodTracker tutorial series
//
// Copyright (c) 2020-2021 AppDev@UW.edu and the SwiftUI FoodTracker authors
// Licensed under MIT License
//
// See https://github.com/UWAppDev/SwiftUI-FoodTracker/blob/main/LICENSE
// for license information
// See https://github.com/UWAppDev/SwiftUI-FoodTracker/graphs/contributors
// for the list of SwiftUI FoodTracker project authors
//
//===----------------------------------------------------------------------===//

import Foundation

// NOTE: follow the original doc for how to implement this file step by step.
struct Meal: Equatable, Identifiable {
    // MARK: Properties
    #warning("TODO: TRY CONVERT TO LET CONSTANTS")
    let id: UUID
    var name: String
    var photo: NativeImage?
    var rating: Int
    
    // MARK: Initialization
    // NOTE: the `?` is added when compiler prompted to do so
    init?(id: UUID = UUID(), name: String, photo: NativeImage?, rating: Int) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
         
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }

        // Initialize stored properties.
        self.id = id
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
