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

import SwiftUI

struct MealEditor: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var meal: Meal
    @State private var mealTitle: String = ""
    @State private var photo: NativeImage? = nil
    @State private var rating: Int = 0
    
    var newMeal: Meal? {
        Meal(id: meal.id, name: mealTitle, photo: photo, rating: rating)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                TextField("Meal Name", text: $mealTitle)
                    .textFieldStyle(.roundedBorder)
                
                StarRating(title: Text("rating"), value: $rating)
                
                ImagePicker(selectedPhoto: $photo)
            }
            .padding()
        }
        .navigationTitle(mealTitle.isEmpty ? meal.name : mealTitle)
        .toolbar {
            Button {
                meal = newMeal!
                #if os(iOS)
                // this is already handled on macOS.
                // calling dismiss will actually close the app :(
                dismiss()
                #endif
            } label: {
                Text("Save")
            }
            .disabled(newMeal == nil || newMeal == meal)
        }
        .onAppear {
            mealTitle = meal.name
            photo = meal.photo
            rating = meal.rating
        }
    }
}

struct EditView_Previews: PreviewProvider {
    @State static var meal = Meal(
        name: "Pasta with Meatballs But Long Name Is Very Long",
        photo: #imageLiteral(resourceName: "meal3"),
        rating: 3
    )!
    
    static var previews: some View {
        NavigationView {
            MealEditor(meal: $meal)
        }
    }
}
