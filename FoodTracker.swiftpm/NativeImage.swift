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

// NOTE: we have many ways to handle this cross platform support.
// We could hand this file out as "starter code", or
// we assume UIKit/iOS and later add necessary changes for macOS

import SwiftUI

#if canImport(UIKit)
import UIKit
typealias NativeImage = UIImage
extension Image {
    init(nativeImage: NativeImage) {
        self.init(uiImage: nativeImage)
    }
}
#else
import AppKit
typealias NativeImage = NSImage
extension Image {
    init(nativeImage: NativeImage) {
        self.init(nsImage: nativeImage)
    }
}
#endif
