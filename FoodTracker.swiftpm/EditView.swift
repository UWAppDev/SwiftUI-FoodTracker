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

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var meal: Meal
    @State var mealTitle: String = ""
    @State var photo: NativeImage? = nil
    @State var rating: Int = 0
    
    var newMeal: Meal? {
        Meal(name: mealTitle, photo: photo, rating: rating)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                TextField("Meal Name", text: $mealTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // TODO: accept new images
                if let photo = meal.photo {
                    Image(nativeImage: photo)
                        // NOTE: check the preview before adding these as fixes
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                } else {
                    Image(systemName: "cup.and.saucer")
                        // NOTE: new SwiftUI feature for SFSymbol
                        .symbolVariant(.fill)
                        .imageScale(.large)
                }

                StarRating(title: Text("rating"), value: $rating)
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
    static var previews: some View {
        NavigationView {
            EditView(meal: .constant(Meal(name: "Pasta with Meatballs But Long Name Is Very Long", photo: #imageLiteral(resourceName: "meal3"), rating: 3)!))
        }
    }
}
