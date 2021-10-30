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
    @State var items: [Int] = []
    @State var value = 0

    var body: some View {
        NavigationView {
            VStack {
                ForEach(items, id: \.self) { item in
                    Text("\(item)")
                }

                StarRating(title: "interactive stars", value: $value)
                    .accentColor(.yellow)
                StarRatingDisplay(title: "static stars", value: 5)
                    .accentColor(.red)
            }
            .navigationTitle(Text("Your Meals"))
            .toolbar {
                Button {
                    // TODO: Add meal
                    withAnimation {
                        items.append(Int.random(in: Int.min...Int.max))
                    }
                } label: {
                    Label("Add meal", systemImage: "plus")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
