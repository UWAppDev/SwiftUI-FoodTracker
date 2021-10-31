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
    // NOTE: we start with a simple state, and gradually change more advanced
    // @State var meals: [Meal] = ContentView_Previews.meals
    // @ObservedObject var mealStore: MealStore = MealStore()
    @EnvironmentObject var mealStore: MealStore
    @State var showingNewMealModal: Bool = false
    @State var query: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach($mealStore.meals) { $meal in
                    if query.isEmpty || meal.name.localizedCaseInsensitiveContains(query) {
                        NavigationLink(destination: EditView(meal: $meal)) {
                            // NOTE: command+click on HStack, then extract
                            MealDisplay(meal: meal)
                        }
                    }
                }
                .onDelete { offsets in
                    mealStore.meals.remove(atOffsets: offsets)
                }
            }
            .navigationTitle(Text("Your Meals"))
            .searchable(text: $query)
            .toolbar {
                Button {
                    showingNewMealModal = true
                } label: {
                    Label("Add meal", systemImage: "plus")
                }
                .sheet(isPresented: $showingNewMealModal) {
                    NavigationView {
                        NewMealModalView()
                    }
                }
            }
            Text("Select a meal to view details")
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
                        .scaledToFill()
                } else {
                    Image(systemName: "cup.and.saucer")
                        // NOTE: new SwiftUI feature for SFSymbol
                        .symbolVariant(.fill)
                        .imageScale(.large)
                }
            }
            .frame(width: 80, height: 80)
            .clipped()
            
            VStack(alignment: .leading) {
                Spacer()
                Text(meal.name)
                    .font(.title2)
                    .lineLimit(2)
                    // make sure it takes max width possible
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                StarRatingDisplay(title: Text("rating"), value: meal.rating)
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
    }
}

struct NewMealModalView: View {
    @EnvironmentObject var mealStore: MealStore
    @Environment(\.dismiss) var dismiss
    
    @State var mealTitle: String = ""
    @State var photo: NativeImage? = nil
    @State var rating: Int = 0
    @State var showPhotoPicker: Bool = false
    
    var newMeal: Meal? {
        Meal(id: UUID(), name: mealTitle, photo: photo, rating: rating)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Meal Name", text: $mealTitle)
                .textFieldStyle(.roundedBorder)
            
            StarRating(title: Text("rating"), value: $rating)
            
            ImageView(photo: $photo, showPhotoPicker: $showPhotoPicker)
        }
        .padding()
        .navigationTitle(mealTitle.isEmpty ? "New Meal" : mealTitle)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    //showingNewMealModal = false
                    #if os(iOS)
                        // this is already handled on macOS.
                        // calling dismiss will actually close the app :(
                        dismiss()
                    #endif
                } label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    #if os(iOS)
                        // this is already handled on macOS.
                        // calling dismiss will actually close the app :(
                        dismiss()
                    #endif
                    mealStore.meals.append(newMeal!)
                } label: {
                    Text("Save")
                }
                .disabled(mealTitle.isEmpty)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    // static let meals = MealStore.sampleMeals
    
    static var previews: some View {
        ContentView()
        
        ContentView()
            .environment(\.colorScheme, .dark)
        
        ContentView()
    }
}
