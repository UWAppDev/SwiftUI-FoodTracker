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

struct ContentView: View {
    @State var meals: [Meal] = ContentView_Previews.meals
    
    var body: some View {
        NavigationView {
            List {
                ForEach($meals) { $meal in
                    // NOTE: command+click on HStack, then extract
                    NavigationLink(destination: EditView(meal: $meal)) {
                        MealDisplay(meal: meal)
                    }
                }
                .onDelete { offsets in
                    meals.remove(atOffsets: offsets)
                }
            }
            .navigationTitle(Text("Your Meals"))
            .toolbar {
                Button {
                    // TODO: Add meal
                    withAnimation {
                        meals.append(Meal(name: "yes", photo: nil, rating: 1)!)
                    }
                } label: {
                    Label("Add meal", systemImage: "plus")
                }
            }
        }
    }
}

// NOTE: extracted
struct MealDisplay: View {
    let meal: Meal

    var body: some View {
        HStack(spacing: 16) {
            // NOTE: Group is added so we can apply `.frame` on either Image
            // and so that they can be consistent in layout
            Group {
                if let photo = meal.photo {
                    Image(nativeImage: photo)
                        // NOTE: check the preview before adding these as fixes
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                } else {
                    Image(systemName: "cup.and.saucer")
                        // NOTE: new SwiftUI feature for SFSymbol
                        .symbolVariant(.fill)
                        .imageScale(.large)
                }
            }
            .frame(width: 80, height: 80)

            
            VStack(alignment: .leading) {
                Spacer()
                Text(meal.name)
                    .font(.title2)
                Spacer()
                StarRatingDisplay(title: Text("rating"), value: meal.rating)
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let meals = [
        Meal(name: "Caprese Salad", photo: #imageLiteral(resourceName: "meal1"), rating: 4)!,
        Meal(name: "Chicken and Potatoes", photo: #imageLiteral(resourceName: "meal2"), rating: 5)!,
        Meal(name: "Pasta with Meatballs But Long Name Is Very Long", photo: #imageLiteral(resourceName: "meal3"), rating: 3)!,
        Meal(name: "No Image And Very Long Name", photo: nil, rating: 1)!,
        Meal(name: "A", photo: nil, rating: 1)!,
    ]
    
    static var previews: some View {
        ContentView(meals: meals)
        
        ContentView(meals: meals)
            .environment(\.colorScheme, .dark)
        
        ContentView()
    }
}
