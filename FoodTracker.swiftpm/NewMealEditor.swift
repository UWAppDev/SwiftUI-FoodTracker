//
//  NewMealEditor.swift
//  FoodTracker
//
//  Created by Apollo Zhu on 11/1/21.
//  Copyright © 2021 AppDev@UW.edu. All rights reserved.
//

import SwiftUI

#warning("TODO: this is very close to MealEditor. Refactor")
struct NewMealEditor: View {
    @EnvironmentObject var mealStore: MealStore
    @Environment(\.dismiss) var dismiss
    
    @State private var mealTitle: String = ""
    @State private var photo: NativeImage? = nil
    @State private var rating: Int = 0
    
    var newMeal: Meal? {
        Meal(name: mealTitle, photo: photo, rating: rating)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Meal Name", text: $mealTitle)
                .textFieldStyle(.roundedBorder)
            
            StarRating(title: Text("rating"), value: $rating)
            
            PhotoPicker(selectedPhoto: $photo)
        }
        .padding()
        .navigationTitle(mealTitle.isEmpty ? "New Meal" : mealTitle)
        .toolbar {
            #if os(iOS)
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    // this is already handled on macOS.
                    // calling dismiss will actually close the app :(
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
            }
            #endif

            #if os(iOS)
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    mealStore.meals.append(newMeal!)
                } label: {
                    Text("Save")
                }
                .disabled(newMeal == nil)
            }
            #else
            Button {
                mealStore.meals.append(newMeal!)
            } label: {
                Text("Save")
            }
            .disabled(newMeal == nil)
            #endif
            
        }
    }
}

struct NewMealEditor_Previews: PreviewProvider {
    static var previews: some View {
        NewMealEditor()
    }
}
