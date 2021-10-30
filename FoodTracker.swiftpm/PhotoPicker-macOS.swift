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

extension View {
    func photoImporter(
        isPresented: Binding<Bool>,
        onCompletion: @escaping (Result<NativeImage, Error>) -> Void
    ) -> some View {
        self.fileImporter(isPresented: isPresented,
                          allowedContentTypes: [.image]) { result in
            onCompletion(result.flatMap { url in
                Result<NSImage, Error> {
                    if let image = NSImage(contentsOf: url) {
                        return image
                    }
                    throw URLError(.cannotOpenFile)
                }
            })
        }
    }
    
    func photoImporter(
        isPresented: Binding<Bool>,
        allowsMultipleSelection: Bool,
        onCompletion: @escaping (Result<[NativeImage], Error>) -> Void
    ) -> some View {
        self.fileImporter(isPresented: isPresented,
                          allowedContentTypes: [.image],
                          allowsMultipleSelection: allowsMultipleSelection) { result in
            onCompletion(result.flatMap { urls in
                Result<[NSImage], Error> {
                    try urls.map { url in
                        if let image = NSImage(contentsOf: url) {
                            return image
                        }
                        throw URLError(.cannotOpenFile)
                    }
                }
            })
        }
    }
}

struct PhotoPicker_Previews: PreviewProvider {
    @State
    static var showImagePicker: Bool = false
    @State
    static var image: Image = Image(systemName: "photo")

    static var previews: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Button {
                    showImagePicker = true
                } label: {
                    Text("Select Image")
                }
                
                if let image = image {
                    image
                }
                Spacer()
            }
            Spacer()
        }
        .photoImporter(isPresented: $showImagePicker) { result in
            switch result {
            case .success(let nativeImage):
                image = Image(nativeImage: nativeImage)
            case .failure(let error):
                print(error)
                image = Image(systemName: "x.circle")
            }
        }
    }
}
