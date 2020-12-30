//
//  SupportingViews.swift
//  FoodTracker
//
//  Copyright © 2020 UWAppDev. All rights reserved.
//

import SwiftUI

struct RatingStars: View {
    @Binding var rating: Int
    var body: some View {
        HStack(alignment: .center, spacing: 0.5) {
            Button(action: {self.rating = (self.rating != 1) ? 1 : 0}) {
                Image(systemName: ((1...5).contains(rating)) ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
            }
            Button(action: {self.rating = (self.rating != 2) ? 2 : 0}) {
                Image(systemName: ((2...5).contains(rating)) ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
            }
            Button(action: {self.rating = (self.rating != 3) ? 3 : 0}) {
                Image(systemName: ((3...5).contains(rating)) ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
            }
            Button(action: {self.rating = (self.rating != 4) ? 4 : 0}) {
                Image(systemName: ((4...5).contains(rating)) ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
            }
            Button(action: {self.rating = (self.rating != 5) ? 5 : 0}) {
                Image(systemName: (rating == 5) ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
            }
        }
    }
}

struct RatingStars_Previews: PreviewProvider {
    static var previews: some View {
        RatingStars(rating: .constant(0))
    }
}
