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

import Combine
import Foundation

// NOTE: to keep things simple, let's use ``UserDefaults``
class MealStore/*UserDefaults*/: ObservableObject {
    // NOTE: unfortunately, normal didSet doesn't work here
    @Published var meals: [Meal]
    private var cancellable: AnyCancellable?
    
    static let sampleMeals = [
        Meal(name: "Caprese Salad", photo: #imageLiteral(resourceName: "meal1"), rating: 4)!,
        Meal(name: "Chicken and Potatoes", photo: #imageLiteral(resourceName: "meal2"), rating: 5)!,
        Meal(name: "Pasta with Meatballs But Long Name Is Very Long", photo: #imageLiteral(resourceName: "meal3"), rating: 3)!,
        Meal(name: "No Image And Very Long Name", photo: nil, rating: 1)!,
        Meal(name: "A", photo: nil, rating: 1)!,
    ]
    
    init() {
        self.meals = Self.savedMeals ?? Self.sampleMeals
        cancellable = $meals.sink(receiveValue: save)
    }
    
    // NOTE: it's very important to have ``savedMeals`` and ``save(_:)``
    // so later we can have different implementations (e.g. Firebase) and
    // not need to change other parts of MealStore
    static var savedMeals: [Meal]? {
        if let storedMealsData = UserDefaults.standard.data(forKey: "meals") {
            do {
                return try PropertyListDecoder()
                    .decode([UserDefaultsMeal].self, from: storedMealsData)
                    .map { try $0.meal }
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    func save(_ newValue: [Meal]) {
        do {
            let storableMeals = try newValue.map(UserDefaultsMeal.init)
            let data = try PropertyListEncoder().encode(storableMeals)
            UserDefaults.standard.set(data, forKey: "meals")
        } catch {
            print(error)
        }
    }
}

struct UserDefaultsMeal: Codable {
    let id: UUID
    let name: String
    let photoData: Data?
    let rating: Int
}

extension UserDefaultsMeal {
    init(meal: Meal) throws {
        self.id = meal.id
        self.name = meal.name
        if let photo = meal.photo {
            guard let data = photo.data else {
                // NOTE: we should probably have an error struct somewhere
                // but I'm too lazy to write that for now
                throw EncodingError.invalidValue(photo, EncodingError.Context(
                    codingPath: [],
                    debugDescription: "can't encode NativeImage as Data",
                    underlyingError: nil
                ))
            }
            self.photoData = data
        } else {
            self.photoData = nil
        }
        self.rating = meal.rating
    }
    
    var meal: Meal {
        get throws {
            var photo: NativeImage?
            if let data = photoData {
                guard let image = NativeImage(data: data) else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(
                        codingPath: [],
                        debugDescription: "can't decode data as NativeImage",
                        underlyingError: nil
                    ))
                }
                photo = image
            } else {
                photo = nil
            }
            
            guard let meal = Meal(id: id,
                                  name: name,
                                  photo: photo,
                                  rating: rating) else {
                throw CocoaError(.coderReadCorrupt)
            }
            return meal
        }
    }
}
