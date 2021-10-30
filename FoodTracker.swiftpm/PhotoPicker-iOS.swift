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
import UniformTypeIdentifiers

extension View {
    func photoImporter(
        isPresented: Binding<Bool>,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) -> some View {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1  // the default
        configuration.filter = .images
        
        return self.sheet(isPresented: isPresented) {
            PhotoPicker(
                isPresented: isPresented,
                configuration: configuration
            ) { result in
                onCompletion(result.flatMap { urls in
                    if let url = urls.first {
                        return .success(url)
                    }
                    return .failure(CocoaError(.userCancelled))
                })
            }
        }
    }
    
    func photoImporter(
        isPresented: Binding<Bool>,
        allowsMultipleSelection: Bool,
        onCompletion: @escaping (Result<[URL], Error>) -> Void
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
    let onCompletion: (Result<[URL], Error>) -> Void
    
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
                    let images = try await imageURLs(from: results)
                    complete(with: .success(images))
                } catch {
                    complete(with: .failure(error))
                }
            }
        }
        
        // Explore structured concurrency in Swift
        // https://developer.apple.com/wwdc21/10134
        private func imageURLs(from phPickerResults: [PHPickerResult]) async throws -> [URL] {
            try await withThrowingTaskGroup(of: URL.self) { group in
                var imageURLs = [URL]()
                imageURLs.reserveCapacity(phPickerResults.count)

                for result in phPickerResults {
                    guard result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) else {
                        throw AVError(.failedToLoadMediaData)
                    }
                    group.addTask {
                        try await result.itemProvider.loadItem(forTypeIdentifier: UTType.image.identifier) as! URL
                    }
                }
                
                // Obtain results from the child tasks, sequentially.
                for try await imageURL in group {
                    imageURLs.append(imageURL)
                }
                return imageURLs
            }
        }
        
        private func complete(with result: Result<[URL], Error>) {
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
    static var image: AsyncImage = AsyncImage(url: nil)
    
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
            case .success(let url):
                image = AsyncImage(url: url)
            case .failure(let error):
                print(error)
                image = AsyncImage(url: nil)
            }
        }
    }
}
