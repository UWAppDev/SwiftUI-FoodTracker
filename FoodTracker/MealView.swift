//
//  ContentView.swift
//  FoodTracker
//
//  Copyright © 2020 UWAppDev. All rights reserved.
//

import SwiftUI
import Introspect

struct MealView: View {
    @State var meal: Meal// = Meal(name: "Untitled Meal", rating: 4)!
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text("Meal Name")
            TextField("Enter meal name", text: $meal.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .introspectTextField { (textField) in
                    textField.returnKeyType = .done
                    textField.enablesReturnKeyAutomatically = true
            }
            Button(action: { self.meal.name = "Untitled Meal" }) {
                Text("Set Default Label Text")
            }
            RatingStars(rating: $meal.rating)
            Spacer()
        }
        .padding(.all)
    }
}

//struct MealView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealView()
//    }
//}
