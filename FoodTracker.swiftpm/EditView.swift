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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var meal: Meal
    @State var mealTitle: String = ""
    @State var photo: NativeImage? = nil
    @State var rating: Int = 0
    
    var body: some View {
        VStack {
            TextField("Meal Name", text: $mealTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            if let photo = meal.photo {
                Image(nativeImage: photo)
                    // NOTE: check the preview before adding these as fixes
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
            } else {
                Image(systemName: "cup.and.saucer")
                    // NOTE: new SwiftUI feature for SFSymbol
                    .symbolVariant(.fill)
                    .imageScale(.large)
            }
            StarRatingDisplay(title: Text("rating"), value: rating)
            Spacer()
        }
        .navigationTitle(mealTitle.isEmpty ? meal.name : mealTitle)
        .toolbar {
            Button {
                meal.name = mealTitle
                meal.photo = photo
                meal.rating = rating
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
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
