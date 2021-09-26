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

// TODO: How about an uneditable version?
// TODO: accessibility representation
struct StarRating: View {
    // TODO: any validation (0...maximumValue)?
    @Binding var value: Int
    let maximumValue = 5

    var body: some View {
        HStack {
            ForEach(1...maximumValue, id: \.self) { index in
                Button {
                    value = index
                } label: {
                    Image(systemName: index <= value ? "star.fill" : "star")
                }
            }
        }
    }
}

struct StarRating_Previews: PreviewProvider {
    @State static var value: Int = 3

    static var previews: some View {
        StarRating(value: $value)
    }
}
