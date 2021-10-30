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

protocol CodableImage: Codable {
    init(nativeImage: NativeImage) throws
    var nativeImage: NativeImage { get throws }
}

struct CodableMeal<Photo: CodableImage>: Codable {
    let name: String
    let photo: Photo?
    let rating: Int
}

extension CodableMeal {
    init(meal: Meal) throws {
        self.name = meal.name
        if let photo = meal.photo {
            self.photo = try Photo(nativeImage: photo)
        } else {
            self.photo = nil
        }
        self.rating = meal.rating
    }
    
    var meal: Meal {
        get throws {
            guard let meal = Meal(name: name,
                                  photo: try photo?.nativeImage,
                                  rating: rating) else {
                throw CocoaError(.coderReadCorrupt)
            }
            return meal
        }
    }
}

extension Data: CodableImage {
    init(nativeImage: NativeImage) throws {
        guard let data = nativeImage.data else {
            throw EncodingError.invalidValue(nativeImage, EncodingError.Context(
                codingPath: [],
                debugDescription: "can't encode NativeImage as Data",
                underlyingError: nil
            ))
        }
        self = data
    }
    
    var nativeImage: NativeImage {
        get throws {
            guard let image = NativeImage(data: self) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: [],
                    debugDescription: "can't decode data as NativeImage",
                    underlyingError: nil
                ))
            }
            return image
        }
    }
}

import Combine

class MealStore: ObservableObject {
    @Published
    var meals: [Meal]
    private var cancellable: AnyCancellable?
    
    static let sampleMeals = [
        Meal(name: "Caprese Salad", photo: #imageLiteral(resourceName: "meal1"), rating: 4)!,
        Meal(name: "Chicken and Potatoes", photo: #imageLiteral(resourceName: "meal2"), rating: 5)!,
        Meal(name: "Pasta with Meatballs But Long Name Is Very Long", photo: #imageLiteral(resourceName: "meal3"), rating: 3)!,
        Meal(name: "No Image And Very Long Name", photo: nil, rating: 1)!,
        Meal(name: "A", photo: nil, rating: 1)!,
    ]
    
    init() {
        if let storedMealsData = UserDefaults.standard.data(forKey: "meals"),
           let storedMeals = try? PropertyListDecoder().decode([CodableMeal<Data>].self,
                                                               from: storedMealsData),
           let meals = try? storedMeals.map({ try $0.meal }) {
            self.meals = meals
        } else {
            self.meals = Self.sampleMeals
        }
        cancellable = $meals.sink { newValue in
            do {
                let storableMeals = try newValue.map(CodableMeal<Data>.init)
                let data = try PropertyListEncoder().encode(storableMeals)
                UserDefaults.standard.set(data, forKey: "meals")
            } catch {
                print(error)
            }
        }
    }
}
