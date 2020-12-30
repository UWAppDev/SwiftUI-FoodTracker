//
//  MealListView.swift
//  FoodTracker
//
//  Created by Lucas Wang on 2020-12-30.
//  Copyright © 2020 UWAppDev. All rights reserved.
//

import SwiftUI

struct MealListView: View {
    let testListofMeals : [Meal] = [Meal(name: "tomato", rating: 4)!, Meal(name: "leftovers", rating: 3)!]
    
    var body: some View {
        if #available(iOS 14.0, *) {
            List(testListofMeals) { chosenMeal in
                NavigationLink(destination: MealView(meal: chosenMeal)) {
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 15) {
                        Text(chosenMeal.name)
                            .foregroundColor(.white)
                            .font(.largeTitle).bold()
                        HStack {
                            ForEach((0...chosenMeal.rating), id: \.self) { star in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(5)
            }
            .listStyle(SidebarListStyle()) // iOS 14 only, floating bubbles with no seperator lines
        } else {
            // Fallback on earlier versions
            List(testListofMeals) { meal in
                NavigationLink(destination: MealView(meal: meal)) {
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 4) {
                        Text(meal.name)
                        HStack {
                            ForEach((0...meal.rating), id: \.self) { star in
                                Image(systemName: "star.fill")
                            }
                        }
                    }
                }
                .padding()
                .background(Color.red)
                .cornerRadius(5)
                .shadow(radius: 15)
            }
            .onAppear{ UITableView.appearance().separatorStyle = .none }
            .onDisappear{ UITableView.appearance().separatorStyle = .singleLine }
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
