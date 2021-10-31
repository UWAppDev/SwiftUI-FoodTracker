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
    @State var showPhotoPicker: Bool = false
    
    var newMeal: Meal? {
        Meal(name: mealTitle, photo: photo, rating: rating)
    }
    
    var image: some View {
        Button {
            showPhotoPicker = true
        } label: {
            if let photo = photo {
                // https://stackoverflow.com/a/69466499
                Color.clear
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(Image(nativeImage: photo)
                                    .resizable()
                                    .scaledToFill())
                    .clipped()
            } else {
                Text("Select a Photo")
            }
        }
        .buttonStyle(.plain)  // macOS
        .photoImporter(isPresented: $showPhotoPicker) { result in
            switch result {
            case .success(let url):
                Task {
                    do {
                        let data = try Data(contentsOf: url)
                        photo = NativeImage(data: data)
                    } catch {
                        print(error)
                        photo = nil
                    }
                }
            case .failure(let error):
                print(error)
                photo = nil
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                TextField("Meal Name", text: $mealTitle)
                    .textFieldStyle(.roundedBorder)
                
                StarRating(title: Text("rating"), value: $rating)
                
                image
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
            EditView(meal: $meal)
        }
    }
}
