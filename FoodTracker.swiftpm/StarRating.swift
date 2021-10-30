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

// NOTE: we should teach this static version first because
// it doesn't have a lot of the SwiftUI @State/@Binding things
struct StarRatingDisplay: View {
    let title: LocalizedStringKey
    let value: Int
    let maximumValue = 5

    var body: some View {
        HStack {
            ForEach(0..<maximumValue) { index in
                // NOTE: unfortunately, we have to teach ternary operator
                // otherwise SwiftUI does funky things when animating
                Image(systemName: index < value ? "star.fill" : "star")
                    .foregroundColor(.accentColor)
            }
        }
        .accessibilityLabel(title)
        .accessibilityValue("\(value) stars our of \(maximumValue) stars")
    }
}

struct StarRating: View {
    let title: LocalizedStringKey
    @Binding var value: Int
    // NOTE: here, we show students the concept of static
    static let maximumValue = 5

    var body: some View {
        HStack {
            // Note: using id: \.self is a common practice that we should show
            ForEach(1...Self.maximumValue, id: \.self) { index in
                Button {
                    value = index
                } label: {
                    Image(systemName: index <= value ? "star.fill" : "star")
                        // we need the following for macOS
                        .foregroundColor(.accentColor)
                }
                // we need the following for macOS
                .buttonStyle(.plain)
                // NOTE: the macOS only lines can probably be added later,
                // as a reminder for students to always double-check for
                // platform differences.
            }
        }
        .accessibilityRepresentation {
            Stepper(title, value: $value, in: 0...Self.maximumValue)
        }
    }
}

struct StarRating_Previews: PreviewProvider {
    @State static var value: Int = 3

    static var previews: some View {
        StarRating(title: "star rating", value: $value)
        
        ForEach(0...StarRating.maximumValue, id: \.self) { i in
            VStack {
                Text("\(i) stars")
                StarRatingDisplay(title: "star rating", value: i)
            }
        }
    }
}
