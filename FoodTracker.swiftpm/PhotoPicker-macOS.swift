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

#if os(macOS)
import SwiftUI

extension View {
    func photoImporter(
        isPresented: Binding<Bool>,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) -> some View {
        self.fileImporter(isPresented: isPresented,
                          allowedContentTypes: [.image],
                          onCompletion: onCompletion)
    }
    
    func photoImporter(
        isPresented: Binding<Bool>,
        allowsMultipleSelection: Bool,
        onCompletion: @escaping (Result<[URL], Error>) -> Void
    ) -> some View {
        self.fileImporter(isPresented: isPresented,
                          allowedContentTypes: [.image],
                          allowsMultipleSelection: allowsMultipleSelection,
                          onCompletion: onCompletion)
    }
}

struct PhotoPicker_Previews: PreviewProvider {
    @State
    static var showImagePicker: Bool = false
    @State
    static var image: AsyncImage = AsyncImage(url: nil)

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
            case .success(let url):
                image = AsyncImage(url: url)
            case .failure(let error):
                print(error)
                image = AsyncImage(url: nil)
            }
        }
    }
}
#endif
