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
import PhotoPicker

struct ImagePicker: View {
    @Binding var selectedPhoto: NativeImage?
    @State var showPhotoPicker: Bool = false
    
    var body: some View {
        Group {
            if let photo = selectedPhoto {
                Button {
                    showPhotoPicker = true
                } label: {
                    // https://stackoverflow.com/a/69466499
                    Color.clear
                        .aspectRatio(1, contentMode: .fit)
                        .background(Image(nativeImage: photo)
                                        .resizable()
                                        .scaledToFill())
                        .clipped()
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Already selected a photo")
                .accessibilityHint("Selects a photo")
            } else {
                Button("Select a Photo") {
                    showPhotoPicker = true
                }
            }
        }
        .photoImporter(isPresented: $showPhotoPicker) { result in
            switch result {
            case .success(let url):
                do {
                    let data = try Data(contentsOf: url)
                    guard let image = NativeImage(data: data) else {
                        throw CocoaError(.coderInvalidValue)
                    }
                    selectedPhoto = image
                } catch {
                    print(error)
                    selectedPhoto = nil
                }
            case .failure(let error):
                print(error)
                selectedPhoto = nil
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(selectedPhoto: .constant(nil))
    }
}
