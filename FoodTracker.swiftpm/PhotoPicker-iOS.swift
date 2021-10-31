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

#if os(iOS)
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

extension View {
    /// Presents a system interface for allowing the user to import an existing
    /// photo.
    ///
    /// In order for the interface to appear, `isPresented` must be `true`. When
    /// the operation is finished, `isPresented` will be set to `false` before
    /// `onCompletion` is called. If the user cancels the operation,
    /// `isPresented` will be set to `false` and `onCompletion` will not be
    /// called.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
    func photoImporter(
        isPresented: Binding<Bool>,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) -> some View {
        self.photoImporter(isPresented: isPresented,
                           allowsMultipleSelection: false) { result in
            onCompletion(result.map { $0.first! })
        }
    }
    
    /// Presents a system interface for allowing the user to import multiple
    /// photos.
    ///
    /// In order for the interface to appear, `isPresented` must be `true`. When
    /// the operation is finished, `isPresented` will be set to `false` before
    /// `onCompletion` is called. If the user cancels the operation,
    /// `isPresented` will be set to `false` and `onCompletion` will not be
    /// called.
    ///
    /// - Note: Changing `allowsMultipleSelection`
    ///   while the file importer is presented will have no immediate effect,
    ///   however will apply the next time it is presented.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - allowsMultipleSelection: Whether the importer allows the user to
    ///     select more than one file to import.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
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
            guard !results.isEmpty else {
                dismiss()
                return
            }
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
                        try await result.itemProvider.imageFileURL
                    }
                }
                
                // Obtain results from the child tasks, sequentially.
                for try await imageURL in group {
                    imageURLs.append(imageURL)
                }
                return imageURLs
            }
        }
        
        private func dismiss() {
            coordinated.isPresented = false
        }
        
        private func complete(with result: Result<[URL], Error>) {
            dismiss()
            coordinated.onCompletion(result)
        }
    }
}

extension NSItemProvider {
    // Meet async/await in Swift
    // https://developer.apple.com/wwdc21/10132/
    var imageFileURL: URL {
        get async throws {
            try await withCheckedThrowingContinuation { continuation in
                // https://developer.apple.com/forums/thread/652496
                loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                    guard let src = url else {
                        return continuation.resume(throwing: error!)
                    }
                    do {
                        // Because the src/url will be deleted once we return,
                        // will copy the stored image to a different temp url.
                        let dst = try FileManager.default.url(
                            for: .itemReplacementDirectory, in: .userDomainMask,
                            appropriateFor: src, create: true
                        ).appendingPathComponent(src.lastPathComponent)
                        if !FileManager.default.fileExists(atPath: dst.path) {
                            try FileManager.default.copyItem(at: src, to: dst)
                        }
                        continuation.resume(returning: dst)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}

struct PhotoPicker_Previews: PreviewProvider {
    @State
    static var showImagePicker: Bool = false
    @State
    static var url: URL? = nil
    
    static var previews: some View {
        VStack {
            Button {
                showImagePicker = true
            } label: {
                Text("Select Image")
            }
            
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                EmptyView()
            }
        }
        .photoImporter(isPresented: $showImagePicker) { result in
            switch result {
            case .success(let url):
                self.url = url
            case .failure(let error):
                print(error)
                url = nil
            }
        }
    }
}
#endif
