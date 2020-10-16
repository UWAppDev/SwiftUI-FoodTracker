//
//  ContentView.swift
//  FoodTracker
//
//  Copyright © 2020 UWAppDev. All rights reserved.
//

import SwiftUI
import Introspect

struct ContentView: View {
    @State var mealName: String = ""
    @State var mealRating: Int = 4
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text("Meal Name")
            TextField("Enter meal name", text: $mealName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .introspectTextField { (textField) in
                    textField.returnKeyType = .done
                    textField.enablesReturnKeyAutomatically = true
            }
            Button(action: {self.mealName = "Untitled Meal"}) {
                Text("Set Default Label Text")
            }
            RatingStars(rating: $mealRating)
            Spacer()
        }
        .padding(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
