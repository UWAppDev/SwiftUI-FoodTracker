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
import PhotosUI

extension View {
    func photoImporter(
        isPresented: Binding<Bool>,
        onCompletion: @escaping (Result<NativeImage, Error>) -> Void
    ) -> some View {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1  // the default
        configuration.filter = .images
        
        return self.sheet(isPresented: isPresented) {
            PhotoPicker(
                isPresented: isPresented,
                configuration: configuration
            ) { result in
                onCompletion(result.flatMap { images in
                    if let image = images.first {
                        return .success(image)
                    }
                    return .failure(CocoaError(.userCancelled))
                })
            }
        }
    }
    
    func photoImporter(
        isPresented: Binding<Bool>,
        allowsMultipleSelection: Bool,
        onCompletion: @escaping (Result<[NativeImage], Error>) -> Void
    ) -> some View {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = allowsMultipleSelection ? 0 : 1
        configuration.filter = .images
        return self.sheet(isPresented: isPresented) {
            PhotoPicker(
                isPresented: isPresented,
                configuration: configuration,
                onCompletion: onCompletion
            )
        }
    }
}

// Meet the new Photos picker
// https://developer.apple.com/wwdc20/10652
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let configuration: PHPickerConfiguration
    let onCompletion: (Result<[NativeImage], Error>) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController,
                                context: Context) {
        // do nothing
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(for: self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let coordinated: PhotoPicker
        
        init(for photoPicker: PhotoPicker) {
            self.coordinated = photoPicker
        }
        
        func picker(_ picker: PHPickerViewController,
                    didFinishPicking results: [PHPickerResult]) {
            Task {
                do {
                    let images = try await uiImages(from: results)
                    complete(with: .success(images))
                } catch {
                    complete(with: .failure(error))
                }
            }
        }
        
        // Explore structured concurrency in Swift
        // https://developer.apple.com/wwdc21/10134
        private func uiImages(from phPickerResults: [PHPickerResult]) async throws -> [UIImage] {
            try await withThrowingTaskGroup(of: UIImage.self) { group in
                var images = [UIImage]()
                images.reserveCapacity(phPickerResults.count)

                for result in phPickerResults {
                    // TODO: Fails for webp, what am I missing?
                    guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
                        throw AVError(.failedToLoadMediaData)
                    }
                    group.addTask {
                        try await result.itemProvider.loadObjectAsync(ofClass: UIImage.self)
                    }
                }
                
                // Obtain results from the child tasks, sequentially.
                for try await image in group {
                    images.append(image)
                }
                return images
            }
        }
        
        private func complete(with result: Result<[NativeImage], Error>) {
            coordinated.isPresented = false
            coordinated.onCompletion(result)
        }
    }
}

extension NSItemProvider {
    // Meet async/await in Swift
    // https://developer.apple.com/wwdc21/10132/
    func loadObjectAsync<T: NSItemProviderReading>(ofClass aClass: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            loadObject(ofClass: aClass) { reading, error in
                if let reading = reading as? T {
                    continuation.resume(returning: reading)
                } else {
                    continuation.resume(throwing: error!)
                }
            }
        }
    }
}

struct PhotoPicker_Previews: PreviewProvider {
    @State
    static var showImagePicker: Bool = false
    @State
    static var image: Image = Image(systemName: "photo")
    
    static var previews: some View {
        VStack {
            Button {
                showImagePicker = true
            } label: {
                Text("Select Image")
            }
            
            if let image = image {
                image
            }
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
