//
//  MealListView.swift
//  FoodTracker
//
//  Created by Lucas Wang on 2020-12-30.
//  Copyright © 2020 UWAppDev. All rights reserved.
//

import SwiftUI

struct MealListView: View {
    let testListOfMeals : [Meal] = [Meal(name: "tomato", rating: 4)!, Meal(name: "leftovers", rating: 3)!]
    
    var body: some View {
        NavigationView {
            List(testListOfMeals) { meal in
                NavigationLink(destination: MealView(meal: meal)) {
                    HStack(alignment: .center, spacing: 15) {
                        Text(meal.name)
                            .foregroundColor(.green)
                            .font(.largeTitle).bold()
                        HStack {
                            ForEach((0...meal.rating), id: \.self) { star in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
